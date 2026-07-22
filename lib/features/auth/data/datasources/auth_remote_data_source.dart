import 'package:google_sign_in/google_sign_in.dart';
import 'package:memory_ticket_app/core/utils/app_logger.dart';
import 'package:memory_ticket_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [AuthRemoteDataSource] handles direct interaction with Supabase services.
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<UserModel> googleSignIn();
  Future<void> logout();
  // Future<void> forgotPassword(String email);
  Future<UserModel?> getCurrentUser();
  Future<bool> isLoggedIn();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  final GoogleSignIn googleSignInInstance;
  final _logger = AppLogger.instance;
  static const _tag = 'AuthRemoteDataSource';

  AuthRemoteDataSourceImpl({
    required this.supabaseClient,
    required this.googleSignInInstance,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    _logger.i('Attempting login for: $email', tag: _tag);
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        _logger.e('Login failed: User object is null', tag: _tag);
        throw const AuthException('Login failed: User is null');
      }

      // Fetch the profile from the 'profiles' table to get the name
      final profileData = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      if (profileData != null) {
        _logger.i('Profile found in database for login', tag: _tag);
        return UserModel.fromMap(profileData);
      }

      _logger.i('Login successful for UID: ${response.user!.id}, but no profile found', tag: _tag);
      return UserModel.fromSupabase(response.user!);
    } catch (e, stack) {
      _logger.e('Exception during login', tag: _tag, error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    _logger.i('Attempting registration for: $email', tag: _tag);
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );

      if (response.user == null) {
        _logger.e('Registration failed: User object is null', tag: _tag);
        throw const AuthException('Registration failed: User is null');
      }

      final userModel = UserModel.fromSupabase(response.user!).copyWithName(name);

      _logger.i('Registration successful. Saving user to database...', tag: _tag);
      await _saveUserToDatabase(userModel);

      _logger.i('User profile created for UID: ${userModel.id}', tag: _tag);
      return userModel;
    } catch (e, stack) {
      _logger.e('Exception during registration', tag: _tag, error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<UserModel> googleSignIn() async {
    _logger.i('Starting Google Sign-In flow', tag: _tag);
    try {
      final GoogleSignInAccount? googleUser = await googleSignInInstance.signIn();
      if (googleUser == null) {
        _logger.w('Google Sign-In flow cancelled by user', tag: _tag);
        throw const AuthException('Google Sign-In cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        _logger.e('Google Sign-In error: Missing ID Token', tag: _tag);
        throw const AuthException('No ID Token found.');
      }

      _logger.i('Google Auth successful. Exchanging token with Supabase...', tag: _tag);
      final response = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        _logger.e('Supabase Google exchange failed: User is null', tag: _tag);
        throw const AuthException('Google Sign-In failed');
      }

      final userModel = UserModel.fromSupabase(response.user!);
      await _saveUserToDatabase(userModel);

      _logger.i('Google Sign-In completed for UID: ${userModel.id}', tag: _tag);
      return userModel;
    } catch (e, stack) {
      _logger.e('Exception during Google Sign-In', tag: _tag, error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    _logger.i('Logging out user...', tag: _tag);
    try {
      await googleSignInInstance.signOut();
      await supabaseClient.auth.signOut();
      _logger.i('Logout successful', tag: _tag);
    } catch (e, stack) {
      _logger.e('Exception during logout', tag: _tag, error: e, stackTrace: stack);
      rethrow;
    }
  }

/*
  @override
  Future<void> forgotPassword(String email) async {
    _logger.i('Sending password reset email to: $email', tag: _tag);
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
      _logger.i('Password reset request sent', tag: _tag);
    } catch (e, stack) {
      _logger.e('Exception during forgotPassword', tag: _tag, error: e, stackTrace: stack);
      rethrow;
    }
  }
*/

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return null;

    try {
      final profileData = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (profileData != null) {
        return UserModel.fromMap(profileData);
      }
    } catch (e) {
      _logger.e('Error fetching profile in getCurrentUser', tag: _tag, error: e);
    }

    return UserModel.fromSupabase(user);
  }

  @override
  Future<bool> isLoggedIn() async {
    final loggedIn = supabaseClient.auth.currentSession != null;
    _logger.d('Check isLoggedIn: $loggedIn', tag: _tag);
    return loggedIn;
  }

  /// Private helper to save user profile to Supabase 'profiles' table
  Future<void> _saveUserToDatabase(UserModel user) async {
    try {
      await supabaseClient.from('profiles').upsert(user.toMap());
    } catch (e, stack) {
      _logger.e('Failed to save user to profiles table', tag: _tag, error: e, stackTrace: stack);
      rethrow;
    }
  }
}

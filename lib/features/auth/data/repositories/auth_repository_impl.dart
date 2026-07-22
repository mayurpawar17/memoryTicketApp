import 'package:memory_ticket_app/core/utils/app_logger.dart';
import 'package:memory_ticket_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:memory_ticket_app/features/auth/domain/entities/user_entity.dart';
import 'package:memory_ticket_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [AuthRepositoryImpl] implements the [AuthRepository] interface using Supabase.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final _logger = AppLogger.instance;
  static const _tag = 'AuthRepositoryImpl';

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      return await remoteDataSource.login(email, password);
    } on AuthException catch (e) {
      _logger.w('AuthException during login: ${e.message}', tag: _tag);
      throw Exception(e.message);
    } catch (e) {
      _logger.e('Unknown error during login', tag: _tag, error: e);
      throw Exception('An unknown error occurred during login');
    }
  }

  @override
  Future<UserEntity> register(String name, String email, String password) async {
    try {
      return await remoteDataSource.register(name, email, password);
    } on AuthException catch (e) {
      _logger.w('AuthException during registration: ${e.message}', tag: _tag);
      throw Exception(e.message);
    } catch (e) {
      _logger.e('Unknown error during registration', tag: _tag, error: e);
      throw Exception('An unknown error occurred during registration');
    }
  }

  @override
  Future<UserEntity> googleSignIn() async {
    try {
      return await remoteDataSource.googleSignIn();
    } on AuthException catch (e) {
      _logger.w('AuthException during Google login: ${e.message}', tag: _tag);
      throw Exception(e.message);
    } catch (e) {
      if (e.toString().contains('cancelled')) {
        _logger.i('Google Sign-In cancelled', tag: _tag);
        throw Exception('Google Sign-In was cancelled');
      }
      _logger.e('Unknown error during Google Sign-In', tag: _tag, error: e);
      throw Exception('An unknown error occurred during Google Sign-In');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (e) {
      throw Exception('An error occurred during logout');
    }
  }

  /*
  @override
  Future<void> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An error occurred while sending password reset email');
    }
  }
  */

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await remoteDataSource.isLoggedIn();
  }
}

import 'package:memory_ticket_app/features/auth/domain/entities/user_entity.dart';

/// [AuthRepository] defines the contract for authentication operations.
/// This interface follows the Dependency Inversion Principle, allowing the
/// domain layer to remain independent of data source implementations.
abstract class AuthRepository {
  /// Signs in a user with email and password.
  Future<UserEntity> login(String email, String password);

  /// Registers a new user with name, email, and password.
  Future<UserEntity> register(String name, String email, String password);

  /// Signs in a user using Google Authentication.
  Future<UserEntity> googleSignIn();

  /// Logs out the current user.
  Future<void> logout();

  /// Sends a password reset email to the specified address.
  // Future<void> forgotPassword(String email);

  /// Retrieves the currently authenticated user, if any.
  Future<UserEntity?> getCurrentUser();

  /// Checks if a user is currently logged in.
  Future<bool> isLoggedIn();
}

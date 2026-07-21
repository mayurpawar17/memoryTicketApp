import 'package:equatable/equatable.dart';
import 'package:memory_ticket_app/features/auth/domain/entities/user_entity.dart';

enum AuthLoadingType {
  login,
  register,
  google,
  logout,
  forgotPassword,
}

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final AuthLoadingType? loadingType;
  const AuthLoading({this.loadingType});

  @override
  List<Object?> get props => [loadingType];
}

class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class GuestMode extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// A specific state for successful password reset email sent
class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_ticket_app/core/utils/app_logger.dart';
import 'package:memory_ticket_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:memory_ticket_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:memory_ticket_app/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:memory_ticket_app/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:memory_ticket_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:memory_ticket_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:memory_ticket_app/features/auth/domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// [AuthBloc] manages all authentication-related business logic and state.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GoogleLoginUseCase googleLoginUseCase;
  final LogoutUseCase logoutUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final IsLoggedInUseCase isLoggedInUseCase;

  final _logger = AppLogger.instance;
  static const _tag = 'AuthBloc';

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.googleLoginUseCase,
    required this.logoutUseCase,
    required this.forgotPasswordUseCase,
    required this.getCurrentUserUseCase,
    required this.isLoggedInUseCase,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    _logger.d('Transition: ${transition.currentState} -> ${transition.nextState}', tag: _tag);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    _logger.i('AppStarted event received', tag: _tag);
    try {
      final isLoggedIn = await isLoggedInUseCase.call();
      if (isLoggedIn) {
        final user = await getCurrentUserUseCase.call();
        if (user != null) {
          _logger.i('User already authenticated: ${user.email}', tag: _tag);
          emit(Authenticated(user: user));
        } else {
          _logger.w('isLoggedIn is true but user object is null', tag: _tag);
          emit(Unauthenticated());
        }
      } else {
        _logger.i('Starting in GuestMode', tag: _tag);
        emit(GuestMode());
      }
    } catch (e) {
      _logger.e('Error during AppStarted initialization', tag: _tag, error: e);
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(loadingType: AuthLoadingType.login));
    try {
      final user = await loginUseCase.call(event.email, event.password);
      emit(Authenticated(user: user));
    } catch (e) {
      _logger.w('Login failed: $e', tag: _tag);
      emit(AuthFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(loadingType: AuthLoadingType.register));
    try {
      final user = await registerUseCase.call(event.name, event.email, event.password);
      emit(Authenticated(user: user));
    } catch (e) {
      _logger.w('Registration failed: $e', tag: _tag);
      emit(AuthFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onGoogleLoginRequested(GoogleLoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(loadingType: AuthLoadingType.google));
    try {
      final user = await googleLoginUseCase.call();
      emit(Authenticated(user: user));
    } catch (e) {
      _logger.w('Google Sign-In failed or cancelled: $e', tag: _tag);
      emit(AuthFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(loadingType: AuthLoadingType.logout));
    try {
      await logoutUseCase.call();
      emit(GuestMode());
    } catch (e) {
      _logger.e('Logout error', tag: _tag, error: e);
      emit(AuthFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onForgotPasswordRequested(ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(loadingType: AuthLoadingType.forgotPassword));
    try {
      await forgotPasswordUseCase.call(event.email);
      emit(const ForgotPasswordSuccess(message: 'Password reset email sent. Please check your inbox.'));
    } catch (e) {
      _logger.w('Forgot password request failed: $e', tag: _tag);
      emit(AuthFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}

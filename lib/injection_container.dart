import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memory_ticket_app/core/secrets/app_secrets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/forgot_password_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/google_login_usecase.dart';
import 'features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'package:memory_ticket_app/features/memory/data/datasources/memory_remote_data_source.dart';
import 'package:memory_ticket_app/features/memory/domain/usecases/sync_memories.dart';
import 'features/memory/data/datasources/memory_local_data_source.dart';
import 'features/memory/data/repo/memory_repository_impl.dart';
import 'features/memory/domain/repositories/memory_repository.dart';
import 'features/memory/domain/usecases/get_memories.dart';
import 'features/memory/domain/usecases/save_memory.dart';
import 'features/memory/domain/usecases/delete_memory.dart';
import 'features/memory/domain/usecases/toggle_favorite.dart';
import 'features/memory/presentation/bloc/memory_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- AUTH FEATURE ---

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      googleLoginUseCase: sl(),
      logoutUseCase: sl(),
      forgotPasswordUseCase: sl(),
      getCurrentUserUseCase: sl(),
      isLoggedInUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GoogleLoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: sl(),
      googleSignInInstance: sl(),
    ),
  );

  // --- MEMORY FEATURE ---

  // Bloc
  sl.registerFactory(
    () => MemoryBloc(
      getMemories: sl(),
      saveMemory: sl(),
      deleteMemory: sl(),
      toggleFavorite: sl(),
      syncMemories: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMemories(sl<MemoryRepository>()));
  sl.registerLazySingleton(() => SaveMemory(sl<MemoryRepository>()));
  sl.registerLazySingleton(() => DeleteMemory(sl<MemoryRepository>()));
  sl.registerLazySingleton(() => ToggleFavorite(sl<MemoryRepository>()));
  sl.registerLazySingleton(() => SyncMemories(sl<MemoryRepository>()));

  // Repository
  sl.registerLazySingleton<MemoryRepository>(
    () => MemoryRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      supabaseClient: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<MemoryLocalDataSource>(
    () => MemoryLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<MemoryRemoteDataSource>(
    () => MemoryRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // --- EXTERNAL ---
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton(() => GoogleSignIn(serverClientId: AppSecrets.GOOGLE_WEB_CLIENT_ID));
}

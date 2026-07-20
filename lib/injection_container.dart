import 'package:get_it/get_it.dart';
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
  // Bloc
  sl.registerFactory(
    () => MemoryBloc(
      getMemories: sl(),
      saveMemory: sl(),
      deleteMemory: sl(),
      toggleFavorite: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMemories(sl<MemoryRepository>()));
  sl.registerLazySingleton(() => SaveMemory(sl<MemoryRepository>()));
  sl.registerLazySingleton(() => DeleteMemory(sl<MemoryRepository>()));
  sl.registerLazySingleton(() => ToggleFavorite(sl<MemoryRepository>()));

  // Repository
  sl.registerLazySingleton<MemoryRepository>(
    () => MemoryRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MemoryLocalDataSource>(
    () => MemoryLocalDataSourceImpl(),
  );
}

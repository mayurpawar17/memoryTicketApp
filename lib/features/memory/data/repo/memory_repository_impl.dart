import '../../domain/entities/memory.dart';
import '../../domain/repositories/memory_repository.dart';
import '../datasources/memory_local_data_source.dart';
import '../models/memory_model.dart';

class MemoryRepositoryImpl implements MemoryRepository {
  final MemoryLocalDataSource localDataSource;

  MemoryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Memory>> getMemories() async {
    return await localDataSource.getMemories();
  }

  @override
  Future<void> saveMemory(Memory memory) async {
    final memoryModel = MemoryModel(
      id: memory.id,
      title: memory.title,
      description: memory.description,
      location: memory.location,
      date: memory.date,
      imagePath: memory.imagePath,
      category: memory.category,
      isFavorite: memory.isFavorite,
    );
    await localDataSource.saveMemory(memoryModel);
  }

  @override
  Future<void> deleteMemory(String id) async {
    await localDataSource.deleteMemory(id);
  }

  @override
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    await localDataSource.updateFavorite(id, isFavorite);
  }
}

import '../entities/memory.dart';

abstract class MemoryRepository {
  Future<List<Memory>> getMemories();
  Future<void> saveMemory(Memory memory);
  Future<void> deleteMemory(String id);
  Future<void> toggleFavorite(String id, bool isFavorite);
  Future<void> syncWithCloud();
}

import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class SaveMemory {
  final MemoryRepository repository;

  SaveMemory(this.repository);

  Future<void> call(Memory memory) async {
    return await repository.saveMemory(memory);
  }
}

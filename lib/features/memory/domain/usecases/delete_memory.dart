import '../repositories/memory_repository.dart';

class DeleteMemory {
  final MemoryRepository repository;

  DeleteMemory(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteMemory(id);
  }
}

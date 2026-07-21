import '../repositories/memory_repository.dart';

class SyncMemories {
  final MemoryRepository repository;

  SyncMemories(this.repository);

  Future<void> call() async {
    return await repository.syncWithCloud();
  }
}

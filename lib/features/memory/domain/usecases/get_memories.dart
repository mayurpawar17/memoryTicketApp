import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class GetMemories {
  final MemoryRepository repository;

  GetMemories(this.repository);

  Future<List<Memory>> call() async {
    return await repository.getMemories();
  }
}

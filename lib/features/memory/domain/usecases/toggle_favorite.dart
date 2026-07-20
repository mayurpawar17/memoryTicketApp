import '../repositories/memory_repository.dart';

class ToggleFavorite {
  final MemoryRepository repository;

  ToggleFavorite(this.repository);

  Future<void> call(String id, bool isFavorite) async {
    return await repository.toggleFavorite(id, isFavorite);
  }
}

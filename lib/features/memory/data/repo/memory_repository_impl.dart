import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:memory_ticket_app/core/utils/app_logger.dart';
import '../../domain/entities/memory.dart';
import '../../domain/repositories/memory_repository.dart';
import '../datasources/memory_local_data_source.dart';
import '../datasources/memory_remote_data_source.dart';
import '../models/memory_model.dart';

class MemoryRepositoryImpl implements MemoryRepository {
  final MemoryLocalDataSource localDataSource;
  final MemoryRemoteDataSource remoteDataSource;
  final SupabaseClient supabaseClient;
  final _logger = AppLogger.instance;
  static const _tag = 'MemoryRepositoryImpl';

  MemoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.supabaseClient,
  });

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
    
    // Auto-sync if logged in
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId != null) {
      _logger.i('User logged in, triggering auto-sync for memory ${memory.id}', tag: _tag);
      _syncSingleMemory(memoryModel, userId); // Run in background
    }
  }

  @override
  Future<void> deleteMemory(String id) async {
    await localDataSource.deleteMemory(id);
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId != null) {
      await remoteDataSource.deleteRemoteMemory(id);
    }
  }

  @override
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    await localDataSource.updateFavorite(id, isFavorite);
    
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId != null) {
      // Fetch the updated local memory to sync it
      final memories = await localDataSource.getMemories();
      final updatedMemory = memories.firstWhere((m) => m.id == id);
      await remoteDataSource.syncMemory(updatedMemory, userId);
    }
  }

  @override
  Future<void> syncWithCloud() async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      _logger.w('Sync requested but no user logged in', tag: _tag);
      return;
    }

    try {
      _logger.i('Starting full cloud sync for user $userId', tag: _tag);
      
      // 1. Fetch remote memories
      final remoteMemories = await remoteDataSource.fetchRemoteMemories(userId);
      
      // 2. Fetch local memories
      final localMemories = await localDataSource.getMemories();

      // 3. Upload missing local memories to cloud
      for (final local in localMemories) {
        final bool existsInCloud = remoteMemories.any((remote) => remote.id == local.id);
        if (!existsInCloud) {
          await _syncSingleMemory(local, userId);
        }
      }

      // 4. Download missing cloud memories to local
      for (final remote in remoteMemories) {
        final bool existsLocally = localMemories.any((local) => local.id == remote.id);
        if (!existsLocally) {
          await localDataSource.saveMemory(remote);
        }
      }
      
      _logger.i('Sync completed successfully', tag: _tag);
    } catch (e, stack) {
      _logger.e('Sync failed', tag: _tag, error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> _syncSingleMemory(MemoryModel memory, String userId) async {
    try {
      String finalImagePath = memory.imagePath;

      // If image is local, upload it first
      if (!finalImagePath.startsWith('http')) {
        _logger.i('Uploading local image for memory ${memory.id}', tag: _tag);
        finalImagePath = await remoteDataSource.uploadImage(
          memory.imagePath,
          userId,
          memory.id,
        );
        
        // Update local database with the cloud URL
        final updatedMemory = MemoryModel(
          id: memory.id,
          title: memory.title,
          description: memory.description,
          location: memory.location,
          date: memory.date,
          imagePath: finalImagePath,
          category: memory.category,
          isFavorite: memory.isFavorite,
        );
        await localDataSource.saveMemory(updatedMemory);
        
        await remoteDataSource.syncMemory(updatedMemory, userId);
      } else {
        await remoteDataSource.syncMemory(memory, userId);
      }
    } catch (e) {
      _logger.e('Failed to sync single memory ${memory.id}', tag: _tag, error: e);
    }
  }
}

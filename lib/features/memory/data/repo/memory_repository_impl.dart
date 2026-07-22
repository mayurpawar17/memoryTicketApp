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

  String get _currentUserId => supabaseClient.auth.currentUser?.id ?? 'guest';

  @override
  Future<List<Memory>> getMemories() async {
    return await localDataSource.getMemories(_currentUserId);
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
      ticketType: memory.ticketType,
      isFavorite: memory.isFavorite,
    );
    await localDataSource.saveMemory(memoryModel, _currentUserId);

    // Auto-sync if logged in
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId != null) {
      _logger.i('User logged in, triggering auto-sync for memory ${memory.id}',
          tag: _tag);
      // Await sync to prevent race conditions (like double uploads if save is triggered twice)
      await _syncSingleMemory(memoryModel, userId);
    }
  }

  @override
  Future<void> deleteMemory(String id) async {
    await localDataSource.deleteMemory(id, _currentUserId);
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId != null) {
      await remoteDataSource.deleteRemoteMemory(id);
    }
  }

  @override
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    await localDataSource.updateFavorite(id, isFavorite, _currentUserId);
    
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId != null) {
      // Fetch the updated local memory to sync it properly (ensures image is uploaded if needed)
      final memories = await localDataSource.getMemories(userId);
      final updatedMemory = memories.firstWhere((m) => m.id == id);
      await _syncSingleMemory(updatedMemory, userId);
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

      // Optional: Migrate guest memories to this user if they just logged in
      await _migrateGuestMemories(userId);
      
      // 1. Fetch remote memories
      final remoteMemories = await remoteDataSource.fetchRemoteMemories(userId);
      
      // 2. Fetch local memories for this specific user
      final localMemories = await localDataSource.getMemories(userId);

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
          await localDataSource.saveMemory(remote, userId);
        }
      }
      
      _logger.i('Sync completed successfully', tag: _tag);
    } catch (e, stack) {
      _logger.e('Sync failed', tag: _tag, error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> _migrateGuestMemories(String userId) async {
    final guestMemories = await localDataSource.getMemories('guest');
    if (guestMemories.isNotEmpty) {
      _logger.i('Migrating ${guestMemories.length} guest memories to user $userId', tag: _tag);
      for (final memory in guestMemories) {
        // Update local record to the new userId
        await localDataSource.saveMemory(memory, userId);
        // Delete the old guest record
        await localDataSource.deleteMemory(memory.id, 'guest');
      }
    }
  }

  Future<void> _syncSingleMemory(MemoryModel memory, String userId) async {
    try {
      String finalImagePath = memory.imagePath;

      // If image is local, upload it first
      if (!finalImagePath.startsWith('http') && finalImagePath.isNotEmpty) {
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
          ticketType: memory.ticketType,
          isFavorite: memory.isFavorite,
        );
        await localDataSource.saveMemory(updatedMemory, userId);
        
        await remoteDataSource.syncMemory(updatedMemory, userId);
      } else {
        await remoteDataSource.syncMemory(memory, userId);
      }
    } catch (e) {
      _logger.e('Failed to sync single memory ${memory.id}', tag: _tag, error: e);
    }
  }
}

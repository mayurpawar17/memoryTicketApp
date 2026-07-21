import 'dart:io';
import 'package:memory_ticket_app/core/utils/app_logger.dart';
import 'package:memory_ticket_app/features/memory/data/models/memory_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class MemoryRemoteDataSource {
  Future<void> syncMemory(MemoryModel memory, String userId);
  Future<List<MemoryModel>> fetchRemoteMemories(String userId);
  Future<String> uploadImage(String localPath, String userId, String memoryId);
  Future<void> deleteRemoteMemory(String memoryId);
}

class MemoryRemoteDataSourceImpl implements MemoryRemoteDataSource {
  final SupabaseClient supabaseClient;
  final _logger = AppLogger.instance;
  static const _tag = 'MemoryRemoteDataSource';

  MemoryRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> syncMemory(MemoryModel memory, String userId) async {
    try {
      final data = memory.toMap();
      data['user_id'] = userId;
      // Map local to remote field names if necessary. 
      // Our model uses 'imagePath' but remote might use 'image_url'
      data['image_url'] = data.remove('imagePath');
      data['is_favorite'] = data.remove('isFavorite') == 1;

      await supabaseClient.from('memories').upsert(data);
      _logger.i('Synced memory ${memory.id} to cloud', tag: _tag);
    } catch (e, stack) {
      _logger.e('Failed to sync memory ${memory.id}', tag: _tag, error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<List<MemoryModel>> fetchRemoteMemories(String userId) async {
    try {
      final List<Map<String, dynamic>> response = await supabaseClient
          .from('memories')
          .select()
          .eq('user_id', userId);

      return response.map((data) {
        // Map remote field names back to local model expectations
        final map = Map<String, dynamic>.from(data);
        map['imagePath'] = map.remove('image_url');
        map['isFavorite'] = map.remove('is_favorite') == true ? 1 : 0;
        return MemoryModel.fromMap(map);
      }).toList();
    } catch (e, stack) {
      _logger.e('Failed to fetch remote memories', tag: _tag, error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<String> uploadImage(String localPath, String userId, String memoryId) async {
    try {
      final file = File(localPath);
      if (!await file.exists()) {
        throw Exception('Image file not found at $localPath');
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${memoryId}.jpg';
      final path = '$userId/$fileName';

      await supabaseClient.storage.from('memory_images').upload(
            path,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = supabaseClient.storage.from('memory_images').getPublicUrl(path);
      _logger.i('Image uploaded successfully: $publicUrl', tag: _tag);
      return publicUrl;
    } catch (e, stack) {
      _logger.e('Failed to upload image', tag: _tag, error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteRemoteMemory(String memoryId) async {
    try {
      await supabaseClient.from('memories').delete().eq('id', memoryId);
      _logger.i('Deleted remote memory $memoryId', tag: _tag);
    } catch (e) {
      _logger.e('Failed to delete remote memory $memoryId', tag: _tag, error: e);
    }
  }
}

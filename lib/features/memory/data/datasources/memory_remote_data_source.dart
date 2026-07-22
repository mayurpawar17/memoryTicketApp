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
      // Only set image_url if it's a remote URL. 
      // Local paths (e.g., from ImagePicker) should not be stored in the remote database.
      final imagePath = data.remove('imagePath');
      if (imagePath != null && imagePath.startsWith('http')) {
        data['image_url'] = imagePath;
      }

      data['is_favorite'] = data.remove('isFavorite') == 1;
      data['ticket_type'] = data.remove('ticketType');

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
        map['ticketType'] = map.remove('ticket_type');
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

      // 1. Check if there's an existing image for this memory and delete it to avoid duplicates
      final existingResponse = await supabaseClient
          .from('memories')
          .select('image_url')
          .eq('id', memoryId)
          .maybeSingle();

      if (existingResponse != null && existingResponse['image_url'] != null) {
        final String oldImageUrl = existingResponse['image_url'];
        if (oldImageUrl.contains('memory_images/')) {
          final oldPath = oldImageUrl.split('memory_images/').last;
          final decodedOldPath = Uri.decodeComponent(oldPath);
          await supabaseClient.storage.from('memory_images').remove([decodedOldPath]);
          _logger.i('Deleted old image from storage before uploading new one: $decodedOldPath', tag: _tag);
        }
      }

      // 2. Upload new image
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
      // 1. Fetch memory to get image URL before deleting
      final response = await supabaseClient
          .from('memories')
          .select('image_url')
          .eq('id', memoryId)
          .maybeSingle();

      if (response != null && response['image_url'] != null) {
        final String imageUrl = response['image_url'];
        // 2. Delete from storage if it's a Supabase storage URL
        if (imageUrl.contains('memory_images/')) {
          final path = imageUrl.split('memory_images/').last;
          // Decode URL component in case of special characters
          final decodedPath = Uri.decodeComponent(path);
          await supabaseClient.storage.from('memory_images').remove([decodedPath]);
          _logger.i('Deleted image from storage: $decodedPath', tag: _tag);
        }
      }

      // 3. Delete record from database
      await supabaseClient.from('memories').delete().eq('id', memoryId);
      _logger.i('Deleted remote memory $memoryId', tag: _tag);
    } catch (e, stack) {
      _logger.e('Failed to delete remote memory $memoryId', tag: _tag, error: e, stackTrace: stack);
    }
  }
}

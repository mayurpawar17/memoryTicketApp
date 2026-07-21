import 'package:memory_ticket_app/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [UserModel] extends [UserEntity] and provides serialization logic.
/// It acts as a Data Transfer Object (DTO) for Supabase interactions.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
    super.createdAt,
  });

  /// Factory constructor to create a [UserModel] from a Supabase [User].
  factory UserModel.fromSupabase(User user) {
    return UserModel(
      id: user.id,
      name: user.userMetadata?['full_name'] ?? 'Guest',
      email: user.email ?? '',
      photoUrl: user.userMetadata?['avatar_url'],
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }

  /// Factory constructor to create a [UserModel] from a PostgreSQL record (Map).
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photo_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  /// Converts the [UserModel] to a Map for Supabase Database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'created_at': createdAt?.toIso8601String(),
      'last_login': DateTime.now().toIso8601String(),
    };
  }

  /// Helper to update name
  UserModel copyWithName(String newName) {
    return UserModel(
      id: id,
      name: newName,
      email: email,
      photoUrl: photoUrl,
      createdAt: createdAt,
    );
  }
}

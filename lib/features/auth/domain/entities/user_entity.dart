import 'package:equatable/equatable.dart';

/// [UserEntity] represents the core user profile information.
/// It is used across the domain and presentation layers.
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, photoUrl, createdAt];
}

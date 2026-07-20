import '../../domain/entities/memory.dart';

class MemoryModel extends Memory {
  const MemoryModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.date,
    required super.imagePath,
    required super.category,
    super.isFavorite,
  });

  factory MemoryModel.fromMap(Map<String, dynamic> map) {
    return MemoryModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      location: map['location'],
      date: map['date'],
      imagePath: map['imagePath'],
      category: map['category'] ?? '',
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'date': date,
      'imagePath': imagePath,
      'category': category,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
}

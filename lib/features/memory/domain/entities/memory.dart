import 'package:equatable/equatable.dart';

class Memory extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final String date;
  final String imagePath;
  final String category;
  final bool isFavorite;

  const Memory({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.imagePath,
    required this.category,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props =>
      [id, title, description, location, date, imagePath, category, isFavorite];
}

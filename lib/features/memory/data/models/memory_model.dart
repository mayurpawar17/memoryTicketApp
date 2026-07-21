import '../../domain/entities/memory.dart';
import '../../domain/entities/ticket_type.dart';

class MemoryModel extends Memory {
  const MemoryModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.date,
    required super.imagePath,
    required super.category,
    super.ticketType,
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
      ticketType: TicketType.values.firstWhere(
        (e) => e.name == map['ticketType'],
        orElse: () => TicketType.classicTicket,
      ),
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
      'ticketType': ticketType.name,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
}

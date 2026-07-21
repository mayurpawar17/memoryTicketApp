import 'package:equatable/equatable.dart';
import 'ticket_type.dart';

class Memory extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final String date;
  final String imagePath;
  final String category;
  final TicketType ticketType;
  final bool isFavorite;

  const Memory({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.imagePath,
    required this.category,
    this.ticketType = TicketType.classicTicket,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        date,
        imagePath,
        category,
        ticketType,
        isFavorite
      ];
}

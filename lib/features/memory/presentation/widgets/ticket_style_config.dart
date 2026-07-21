import 'package:flutter/material.dart';
import '../../domain/entities/ticket_type.dart';

class TicketStyleConfig {
  final Color backgroundColor;
  final Color accentColor;
  final Color textColor;
  final Color secondaryTextColor;
  final IconData? mainIcon;
  final String? fontFamily;
  final double sidePunchYRatio;

  const TicketStyleConfig({
    required this.backgroundColor,
    required this.accentColor,
    required this.textColor,
    required this.secondaryTextColor,
    this.mainIcon,
    this.fontFamily,
    this.sidePunchYRatio = 0.69,
  });

  factory TicketStyleConfig.fromType(TicketType type) {
    switch (type) {
      case TicketType.flightBoardingPass:
        return const TicketStyleConfig(
          backgroundColor: Color(0xFFE3F2FD),
          accentColor: Color(0xFF1976D2),
          textColor: Color(0xFF0D47A1),
          secondaryTextColor: Color(0xFF546E7A),
          mainIcon: Icons.flight_takeoff,
          sidePunchYRatio: 0.75,
        );
      case TicketType.movieTicket:
        return const TicketStyleConfig(
          backgroundColor: Color(0xFFFFEBEE),
          accentColor: Color(0xFFC62828),
          textColor: Color(0xFFB71C1C),
          secondaryTextColor: Color(0xFF757575),
          mainIcon: Icons.movie,
          sidePunchYRatio: 0.65,
        );
      case TicketType.concertTicket:
        return const TicketStyleConfig(
          backgroundColor: Color(0xFFF3E5F5),
          accentColor: Color(0xFF7B1FA2),
          textColor: Color(0xFF4A148C),
          secondaryTextColor: Color(0xFF6A1B9A),
          mainIcon: Icons.music_note,
        );
      case TicketType.graduationTicket:
        return const TicketStyleConfig(
          backgroundColor: Color(0xFFE8F5E9),
          accentColor: Color(0xFF2E7D32),
          textColor: Color(0xFF1B5E20),
          secondaryTextColor: Color(0xFF388E3C),
          mainIcon: Icons.school,
        );
      case TicketType.cafeReceipt:
        return const TicketStyleConfig(
          backgroundColor: Color(0xFFEFEBE9),
          accentColor: Color(0xFF4E342E),
          textColor: Color(0xFF3E2723),
          secondaryTextColor: Color(0xFF5D4037),
          mainIcon: Icons.coffee,
          sidePunchYRatio: 0.8,
        );
      case TicketType.birthdayTicket:
        return const TicketStyleConfig(
          backgroundColor: Color(0xFFFFF3E0),
          accentColor: Color(0xFFEF6C00),
          textColor: Color(0xFFE65100),
          secondaryTextColor: Color(0xFFF57C00),
          mainIcon: Icons.cake,
        );
      case TicketType.vintageTicket:
        return const TicketStyleConfig(
          backgroundColor: Color(0xFFFFFDE7),
          accentColor: Color(0xFFFBC02D),
          textColor: Color(0xFF827717),
          secondaryTextColor: Color(0xFF9E9D24),
          mainIcon: Icons.history_edu,
        );
      case TicketType.passportStamp:
        return const TicketStyleConfig(
          backgroundColor: Color(0xFFF1F8E9),
          accentColor: Color(0xFF558B2F),
          textColor: Color(0xFF33691E),
          secondaryTextColor: Color(0xFF689F38),
          mainIcon: Icons.public,
        );
      case TicketType.adventurePass:
        return const TicketStyleConfig(
          backgroundColor: Color(0xFFF0F4C3),
          accentColor: Color(0xFF9E9D24),
          textColor: Color(0xFF827717),
          secondaryTextColor: Color(0xFFAFB42B),
          mainIcon: Icons.landscape,
        );
      case TicketType.classicTicket:
      default:
        return const TicketStyleConfig(
          backgroundColor: Colors.white,
          accentColor: Color(0xFF222222),
          textColor: Color(0xFF222222),
          secondaryTextColor: Color(0xFF616161),
          sidePunchYRatio: 0.69,
        );
    }
  }
}

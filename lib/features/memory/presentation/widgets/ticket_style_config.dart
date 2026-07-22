import 'package:flutter/material.dart';
import '../../domain/entities/ticket_type.dart';
import 'ticket_types/ticket_clippers.dart';

class TicketStyleConfig {
  final Color backgroundColor;
  final Color accentColor;
  final Color textColor;
  final Color secondaryTextColor;
  final IconData? mainIcon;
  final IconData? secondaryIcon;
  final bool showBarcode;
  final String? fontFamily;
  final double sidePunchYRatio;
  final TicketType type;

  const TicketStyleConfig({
    required this.backgroundColor,
    required this.accentColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.type,
    this.mainIcon,
    this.secondaryIcon,
    this.showBarcode = false,
    this.fontFamily,
    this.sidePunchYRatio = 0.69,
  });

  CustomClipper<Path> get clipper => TicketClipperFactory.getClipper(type, sidePunchYRatio: sidePunchYRatio);

  factory TicketStyleConfig.fromType(TicketType type) {
    switch (type) {
      case TicketType.flightBoardingPass:
        return TicketStyleConfig(
          type: type,
          backgroundColor: const Color(0xFFE3F2FD),
          accentColor: const Color(0xFF1976D2),
          textColor: const Color(0xFF0D47A1),
          secondaryTextColor: const Color(0xFF546E7A),
          mainIcon: Icons.flight_takeoff,
          secondaryIcon: Icons.airplane_ticket,
          showBarcode: true,
          sidePunchYRatio: 0.75,
        );
      case TicketType.movieTicket:
        return TicketStyleConfig(
          type: type,
          backgroundColor: const Color(0xFFFFEBEE),
          accentColor: const Color(0xFFC62828),
          textColor: const Color(0xFFB71C1C),
          secondaryTextColor: const Color(0xFF757575),
          mainIcon: Icons.movie,
          secondaryIcon: Icons.theaters,
          sidePunchYRatio: 0.65,
        );
      case TicketType.concertTicket:
        return TicketStyleConfig(
          type: type,
          backgroundColor: const Color(0xFFF3E5F5),
          accentColor: const Color(0xFF7B1FA2),
          textColor: const Color(0xFF4A148C),
          secondaryTextColor: const Color(0xFF6A1B9A),
          mainIcon: Icons.music_note,
          secondaryIcon: Icons.confirmation_number,
        );
      case TicketType.graduationTicket:
        return TicketStyleConfig(
          type: type,
          backgroundColor: const Color(0xFFE8F5E9),
          accentColor: const Color(0xFF2E7D32),
          textColor: const Color(0xFF1B5E20),
          secondaryTextColor: const Color(0xFF388E3C),
          mainIcon: Icons.school,
          secondaryIcon: Icons.workspace_premium,
        );
      case TicketType.cafeReceipt:
        return TicketStyleConfig(
          type: type,
          backgroundColor: const Color(0xFFEFEBE9),
          accentColor: const Color(0xFF4E342E),
          textColor: const Color(0xFF3E2723),
          secondaryTextColor: const Color(0xFF5D4037),
          mainIcon: Icons.coffee,
          secondaryIcon: Icons.receipt_long,
          sidePunchYRatio: 0.8,
        );
      case TicketType.birthdayTicket:
        return TicketStyleConfig(
          type: type,
          backgroundColor: const Color(0xFFFFF3E0),
          accentColor: const Color(0xFFEF6C00),
          textColor: const Color(0xFFE65100),
          secondaryTextColor: const Color(0xFFF57C00),
          mainIcon: Icons.cake,
          secondaryIcon: Icons.celebration,
        );
      case TicketType.vintageTicket:
        return TicketStyleConfig(
          type: type,
          backgroundColor: const Color(0xFFFFFDE7),
          accentColor: const Color(0xFFFBC02D),
          textColor: const Color(0xFF827717),
          secondaryTextColor: const Color(0xFF9E9D24),
          mainIcon: Icons.history_edu,
          secondaryIcon: Icons.train,
        );
      case TicketType.passportStamp:
        return TicketStyleConfig(
          type: type,
          backgroundColor: const Color(0xFFF1F8E9),
          accentColor: const Color(0xFF558B2F),
          textColor: const Color(0xFF33691E),
          secondaryTextColor: const Color(0xFF689F38),
          mainIcon: Icons.public,
          secondaryIcon: Icons.map,
        );
      case TicketType.adventurePass:
        return TicketStyleConfig(
          type: type,
          backgroundColor: const Color(0xFFF0F4C3),
          accentColor: const Color(0xFF9E9D24),
          textColor: const Color(0xFF827717),
          secondaryTextColor: const Color(0xFFAFB42B),
          mainIcon: Icons.landscape,
          secondaryIcon: Icons.explore,
        );
      case TicketType.classicTicket:
      default:
        return TicketStyleConfig(
          type: type,
          backgroundColor: Colors.white,
          accentColor: const Color(0xFF222222),
          textColor: const Color(0xFF222222),
          secondaryTextColor: const Color(0xFF616161),
          mainIcon: Icons.confirmation_number_outlined,
          sidePunchYRatio: 0.69,
        );
    }
  }
}

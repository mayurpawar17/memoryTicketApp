import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../domain/entities/ticket_type.dart';

class TicketClipperFactory {
  static CustomClipper<Path> getClipper(TicketType type, {double sidePunchYRatio = 0.69}) {
    switch (type) {
      case TicketType.flightBoardingPass:
        return FlightBoardingPassClipper();
      case TicketType.movieTicket:
        return MovieTicketClipper();
      case TicketType.concertTicket:
        return ConcertTicketClipper();
      case TicketType.graduationTicket:
        return GraduationTicketClipper();
      case TicketType.cafeReceipt:
        return CafeReceiptClipper();
      case TicketType.birthdayTicket:
        return BirthdayTicketClipper();
      case TicketType.vintageTicket:
        return VintageTicketClipper();
      case TicketType.passportStamp:
        return PassportStampClipper();
      case TicketType.adventurePass:
        return AdventurePassClipper();
      case TicketType.classicTicket:
      default:
        return ClassicTicketClipper(sidePunchYRatio: sidePunchYRatio);
    }
  }
}

class FlightBoardingPassClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double stubWidth = 80.0;
    const double punchRadius = 10.0;
    
    path.moveTo(0, 0);
    path.lineTo(size.width - stubWidth - punchRadius, 0);
    path.arcToPoint(
      Offset(size.width - stubWidth + punchRadius, 0),
      radius: const Radius.circular(punchRadius),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - stubWidth + punchRadius, size.height);
    path.arcToPoint(
      Offset(size.width - stubWidth - punchRadius, size.height),
      radius: const Radius.circular(punchRadius),
      clockwise: false,
    );
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MovieTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double sidePunch = 12.0;
    const double smallPunch = 4.0;
    
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    
    // Film strip notches on right
    for (double i = 20; i < size.height - 20; i += 20) {
      path.lineTo(size.width, i);
      path.arcToPoint(Offset(size.width, i + smallPunch * 2),
          radius: const Radius.circular(smallPunch), clockwise: false);
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    
    // Film strip notches on left
    for (double i = size.height - 20; i > 20; i -= 20) {
      path.lineTo(0, i);
      path.arcToPoint(Offset(0, i - smallPunch * 2),
          radius: const Radius.circular(smallPunch), clockwise: false);
    }
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ConcertTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double corner = 15.0;
    
    path.moveTo(corner, 0);
    path.lineTo(size.width - corner, 0);
    path.lineTo(size.width, corner);
    
    // Zig-zag tear on right side
    for (double i = corner; i < size.height - corner; i += 10) {
      path.lineTo(size.width - 5, i + 5);
      path.lineTo(size.width, i + 10);
    }
    
    path.lineTo(size.width - corner, size.height);
    path.lineTo(corner, size.height);
    path.lineTo(0, size.height - corner);
    
    // Zig-zag tear on left side
    for (double i = size.height - corner; i > corner; i -= 10) {
      path.lineTo(5, i - 5);
      path.lineTo(0, i - 10);
    }
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class GraduationTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double curve = 20.0;
    
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    
    // Ribbon notch
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(size.width * 0.7, size.height - 25);
    path.lineTo(size.width * 0.6, size.height);
    
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CafeReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    
    // Random torn thermal edge
    final random = math.Random(42);
    for (double i = size.width; i > 0; i -= 8) {
      path.lineTo(i - 4, size.height - 2 - random.nextDouble() * 6);
      path.lineTo(i - 8, size.height);
    }
    
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BirthdayTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double radius = 12.0;
    
    path.moveTo(0, 0);
    // Scalloped edges
    for (double i = 0; i < size.width; i += radius * 2) {
      path.arcToPoint(Offset(i + radius * 2, 0), radius: const Radius.circular(radius), clockwise: false);
    }
    path.lineTo(size.width, size.height);
    for (double i = size.width; i > 0; i -= radius * 2) {
      path.arcToPoint(Offset(i - radius * 2, size.height), radius: const Radius.circular(radius), clockwise: false);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class VintageTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double c = 30.0; // Corner size
    
    path.moveTo(0, c);
    path.quadraticBezierTo(c/2, c/2, c, 0);
    path.lineTo(size.width - c, 0);
    path.quadraticBezierTo(size.width - c/2, c/2, size.width, c);
    
    path.lineTo(size.width, size.height - c);
    path.quadraticBezierTo(size.width - c/2, size.height - c/2, size.width - c, size.height);
    
    path.lineTo(c, size.height);
    path.quadraticBezierTo(c/2, size.height - c/2, 0, size.height - c);
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PassportStampClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double ripple = 4.0;
    
    path.moveTo(0, 0);
    // Stamp perforations all around
    for (double i = 0; i < size.width; i += ripple * 4) {
      path.lineTo(i + ripple, 0);
      path.arcToPoint(Offset(i + ripple * 3, 0), radius: const Radius.circular(ripple), clockwise: false);
    }
    path.lineTo(size.width, 0);
    for (double i = 0; i < size.height; i += ripple * 4) {
      path.lineTo(size.width, i + ripple);
      path.arcToPoint(Offset(size.width, i + ripple * 3), radius: const Radius.circular(ripple), clockwise: false);
    }
    path.lineTo(size.width, size.height);
    for (double i = size.width; i > 0; i -= ripple * 4) {
      path.lineTo(i - ripple, size.height);
      path.arcToPoint(Offset(i - ripple * 3, size.height), radius: const Radius.circular(ripple), clockwise: false);
    }
    path.lineTo(0, size.height);
    for (double i = size.height; i > 0; i -= ripple * 4) {
      path.lineTo(0, i - ripple);
      path.arcToPoint(Offset(0, i - ripple * 3), radius: const Radius.circular(ripple), clockwise: false);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class AdventurePassClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 20);
    
    // Mountain edge at top
    path.lineTo(size.width * 0.15, 0);
    path.lineTo(size.width * 0.3, 15);
    path.lineTo(size.width * 0.5, 5);
    path.lineTo(size.width * 0.7, 25);
    path.lineTo(size.width * 0.85, 10);
    path.lineTo(size.width, 20);
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ClassicTicketClipper extends CustomClipper<Path> {
  final double sidePunchYRatio;

  const ClassicTicketClipper({this.sidePunchYRatio = 0.69});

  @override
  Path getClip(Size size) {
    final path = Path();
    const double punchRadius = 12.0;
    const double cornerRadius = 8.0;
    final double punchY = size.height * sidePunchYRatio;

    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    
    path.lineTo(size.width, punchY - punchRadius);
    path.arcToPoint(
      Offset(size.width, punchY + punchRadius),
      radius: const Radius.circular(punchRadius),
      clockwise: false,
    );
    
    path.lineTo(size.width, size.height - cornerRadius);
    path.quadraticBezierTo(size.width, size.height, size.width - cornerRadius, size.height);
    path.lineTo(cornerRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

    path.lineTo(0, punchY + punchRadius);
    path.arcToPoint(
      Offset(0, punchY - punchRadius),
      radius: const Radius.circular(punchRadius),
      clockwise: false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

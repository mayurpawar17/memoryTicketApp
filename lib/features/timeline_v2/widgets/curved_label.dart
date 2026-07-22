import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurvedLabel extends StatelessWidget {
  final String text;
  final double radius;
  final TextStyle? style;
  final double startAngle;

  const CurvedLabel({
    super.key,
    required this.text,
    this.radius = 70,
    this.style,
    this.startAngle = -math.pi / 2,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CurvedTextPainter(
        text: text,
        radius: radius,
        style: style ?? GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.6),
          letterSpacing: 2,
        ),
        startAngle: startAngle,
      ),
    );
  }
}

class _CurvedTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final TextStyle style;
  final double startAngle;

  _CurvedTextPainter({
    required this.text,
    required this.radius,
    required this.style,
    required this.startAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    double currentAngle = startAngle;

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final textPainter = TextPainter(
        text: TextSpan(text: char, style: style),
        textDirection: TextDirection.ltr,
      )..layout();

      final charWidth = textPainter.width;
      final charAngle = charWidth / radius;

      // Move to the position on the circle
      final x = radius * math.cos(currentAngle + charAngle / 2);
      final y = radius * math.sin(currentAngle + charAngle / 2);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(currentAngle + charAngle / 2 + math.pi / 2);
      textPainter.paint(canvas, Offset(-charWidth / 2, -textPainter.height / 2));
      canvas.restore();

      currentAngle += charAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedTextPainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.radius != radius ||
        oldDelegate.style != style ||
        oldDelegate.startAngle != startAngle;
  }
}

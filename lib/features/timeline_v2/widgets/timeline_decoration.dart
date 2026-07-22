import 'dart:math' as math;
import 'package:flutter/material.dart';

enum DecorationType { radialBurst, blob, star, rectangle, circle, splash }

class TimelineDecoration extends StatelessWidget {
  final Color color;
  final DecorationType type;

  const TimelineDecoration({
    super.key,
    required this.color,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(180, 180),
      painter: _DecorationPainter(color: color, type: type),
    );
  }
}

class _DecorationPainter extends CustomPainter {
  final Color color;
  final DecorationType type;

  _DecorationPainter({required this.color, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    switch (type) {
      case DecorationType.circle:
        canvas.drawCircle(center, radius * 1.2, paint);
        break;
      case DecorationType.rectangle:
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(math.pi / 6);
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: radius * 2, height: radius * 2),
          paint,
        );
        canvas.restore();
        break;
      case DecorationType.star:
        _drawStar(canvas, center, 8, radius * 1.4, radius * 0.7, paint);
        break;
      case DecorationType.radialBurst:
        _drawBurst(canvas, center, 12, radius * 1.5, paint);
        break;
      case DecorationType.blob:
        _drawBlob(canvas, center, radius * 1.2, paint);
        break;
      case DecorationType.splash:
        _drawSplash(canvas, center, radius, paint);
        break;
    }
  }

  void _drawStar(Canvas canvas, Offset center, int points, double outerRadius, double innerRadius, Paint paint) {
    final path = Path();
    double angle = math.pi / points;
    for (int i = 0; i < 2 * points; i++) {
      double r = (i % 2 == 0) ? outerRadius : innerRadius;
      double x = center.dx + r * math.cos(i * angle - math.pi / 2);
      double y = center.dy + r * math.sin(i * angle - math.pi / 2);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBurst(Canvas canvas, Offset center, int rays, double length, Paint paint) {
    for (int i = 0; i < rays; i++) {
      double angle = (i * 2 * math.pi) / rays;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.drawRect(Rect.fromLTWH(-2, 0, 4, length), paint);
      canvas.restore();
    }
  }

  void _drawBlob(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    final points = 8;
    final random = math.Random(color.value);
    for (int i = 0; i < points; i++) {
      double angle = (i * 2 * math.pi) / points;
      double r = radius * (0.8 + random.nextDouble() * 0.4);
      double x = center.dx + r * math.cos(angle);
      double y = center.dy + r * math.sin(angle);
      if (i == 0) path.moveTo(x, y); else {
        // Simple smoothing would be better with cubicTo but for now...
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawSplash(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
    final random = math.Random(color.value);
    for (int i = 0; i < 5; i++) {
      double angle = random.nextDouble() * 2 * math.pi;
      double dist = radius * (1.1 + random.nextDouble() * 0.4);
      double r = radius * (0.1 + random.nextDouble() * 0.2);
      canvas.drawCircle(
        Offset(center.dx + dist * math.cos(angle), center.dy + dist * math.sin(angle)),
        r,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DecorationPainter oldDelegate) => false;
}

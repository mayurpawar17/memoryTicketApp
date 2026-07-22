import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';

class TimelinePainter extends CustomPainter {
  final double progress;
  final Color color;

  TimelinePainter({required this.progress, this.color = AppColors.primary});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(width / 2, 0);

    double currentY = 0;
    // We want the curve to pass through or near the items.
    // Each item is ~300 height + ~120 margin.
    double segmentHeight = 420; 
    
    int segments = (height / segmentHeight).ceil() + 1;

    for (int i = 0; i < segments; i++) {
      double nextY = currentY + segmentHeight;
      
      if (i % 2 == 0) {
        path.cubicTo(
          width * 0.9, currentY + segmentHeight * 0.3,
          width * 0.9, currentY + segmentHeight * 0.7,
          width / 2, nextY,
        );
      } else {
        path.cubicTo(
          width * 0.1, currentY + segmentHeight * 0.3,
          width * 0.1, currentY + segmentHeight * 0.7,
          width / 2, nextY,
        );
      }
      currentY = nextY;
    }

    // Animate the path
    final pathMetrics = path.computeMetrics();
    final extractPath = Path();
    
    for (var metric in pathMetrics) {
      extractPath.addPath(
        metric.extractPath(0, metric.length * progress),
        Offset.zero,
      );
    }

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant TimelinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

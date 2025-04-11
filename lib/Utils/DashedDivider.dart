import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashHeight;
  final Color color;
  final double spacing;

  DashedDivider({
    Key? key,
    this.height = 1.0,
    this.dashWidth = 10.0,
    this.dashHeight = 1.0,
    this.color = Colors.grey,
    this.spacing = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height), // Full width and specified height
      painter: DashedDividerPainter(
        dashWidth: dashWidth,
        dashHeight: dashHeight,
        color: color,
        spacing: spacing,
      ),
    );
  }
}

class DashedDividerPainter extends CustomPainter {
  final double dashWidth;
  final double dashHeight;
  final Color color;
  final double spacing;

  DashedDividerPainter({
    required this.dashWidth,
    required this.dashHeight,
    required this.color,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = dashHeight;

    double startX = 0;

    // Draw dashed line
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + spacing; // Move to next dash start position
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // No need to repaint as we are not changing the divider dynamically
  }
}

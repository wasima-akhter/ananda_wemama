import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeftRoundRightCutPainter extends CustomPainter {
  final Color fillColor; // 🎨 Background color inside the shape
  final Color borderColor; // 🖊️ Border (outline) color
  final double borderWidth;

  LeftRoundRightCutPainter({
    required this.fillColor,
    required this.borderColor,
    this.borderWidth = 2, // Will be scaled using ScreenUtil
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.height / 2).r; // Responsive radius

    final path = Path();

    // 🔹 Start from top-left curve start
    path.moveTo(radius, 0);

    // 🔹 Top straight line
    path.lineTo(size.width, 0);

    // 🔹 Right vertical cut
    path.lineTo(size.width, size.height);

    // 🔹 Bottom straight line
    path.lineTo(radius, size.height);

    // 🔹 Left smooth half circle
    // path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius), clockwise: true);

    // Perfect half-circle using arcTo
    path.arcTo(
      Rect.fromLTWH(0, 0, radius * 2, size.height),
      90 * (3.1415926535 / 180), // start angle (left bottom)
      180 * (3.1415926535 / 180), // sweep
      false,
    );
    path.close();

    // 🎨 FILL (Background color)
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // 🖊️ BORDER (Outline color)
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth.w; // Responsive stroke width

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RightRoundLeftCutPainter extends CustomPainter {
  final Color fillColor; // 🎨 Background color inside the shape
  final Color borderColor; // 🖊️ Border (outline) color
  final double borderWidth;

  RightRoundLeftCutPainter({
    required this.fillColor,
    required this.borderColor,
    this.borderWidth = 2, // Will be scaled using ScreenUtil
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.height / 2).r; // Responsive radius

    final path = Path();

    // 🔹 Start at top-left (straight cut side)
    path.moveTo(0, 0);

    // 🔹 Top straight line → toward right curve start
    path.lineTo(size.width - radius, 0);

    // 🔹 Right smooth half circle
    // 🔹 Perfect right half circle (smooth arc)
    path.arcTo(
      Rect.fromLTWH(size.width - (radius * 2), 0, radius * 2, size.height),
      -90 * (3.1415926535 / 180), // start angle (top)
      180 * (3.1415926535 / 180), // sweep
      false,
    );

    // 🔹 Bottom straight line → back to left
    path.lineTo(0, size.height);

    // 🔹 Left vertical cut
    path.lineTo(0, 0);

    path.close();

    // 🎨 FILL (Background)
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // 🖊️ BORDER (Outline)
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth.w; // Responsive stroke width

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

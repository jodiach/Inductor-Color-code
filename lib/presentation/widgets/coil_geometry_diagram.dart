import 'package:flutter/material.dart';

enum CoilGeometryType { singleLayer, multiLayer, flatSpiral }

class CoilGeometryDiagram extends StatelessWidget {
  final CoilGeometryType type;

  const CoilGeometryDiagram({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 80,
      child: CustomPaint(
        painter: _CoilGeometryPainter(type: type),
      ),
    );
  }
}

class _CoilGeometryPainter extends CustomPainter {
  final CoilGeometryType type;

  _CoilGeometryPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00F0FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final fillPaint = Paint()
      ..color = const Color(0xFF00F0FF).withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    switch (type) {
      case CoilGeometryType.singleLayer:
        _drawSingleLayer(canvas, size, paint, fillPaint);
        break;
      case CoilGeometryType.multiLayer:
        _drawMultiLayer(canvas, size, paint, fillPaint);
        break;
      case CoilGeometryType.flatSpiral:
        _drawFlatSpiral(canvas, size, paint, fillPaint);
        break;
    }
  }

  void _drawSingleLayer(Canvas canvas, Size size, Paint stroke, Paint fill) {
    // Draw solenoid coil diagram
    final cx = size.width / 2;
    final cy = size.height / 2;
    final coilRadius = 25.0;
    final windingHeight = 40.0;

    // Left wire
    canvas.drawLine(
      Offset(10, cy),
      Offset(cx - coilRadius - 5, cy),
      stroke,
    );

    // Right wire
    canvas.drawLine(
      Offset(cx + coilRadius + 5, cy),
      Offset(size.width - 10, cy),
      stroke,
    );

    // Draw coil loops as arcs
    final loopPaint = Paint()
      ..color = const Color(0xFF00F0FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw several coil loops
    for (int i = 0; i < 6; i++) {
      double xOffset = (i - 2.5) * 10;
      Rect loopRect = Rect.fromCenter(
        center: Offset(cx + xOffset, cy),
        width: 8,
        height: windingHeight,
      );
      canvas.drawArc(loopRect, -3.14 / 2, 3.14, false, loopPaint);
    }

    // Label lines
    final labelPaint = Paint()
      ..color = Colors.white54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // D label (diameter)
    canvas.drawLine(
      Offset(cx - coilRadius, cy - windingHeight / 2 - 5),
      Offset(cx + coilRadius, cy - windingHeight / 2 - 5),
      labelPaint,
    );
    canvas.drawLine(
      Offset(cx - coilRadius, cy - windingHeight / 2 - 8),
      Offset(cx - coilRadius, cy - windingHeight / 2),
      labelPaint,
    );
    canvas.drawLine(
      Offset(cx + coilRadius, cy - windingHeight / 2 - 8),
      Offset(cx + coilRadius, cy - windingHeight / 2),
      labelPaint,
    );
  }

  void _drawMultiLayer(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Inner circle
    double innerRadius = 15;
    double outerRadius = 30;

    // Outer ellipse/wound coil
    final outerRect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: outerRadius * 2,
      height: outerRadius * 1.6,
    );
    canvas.drawOval(outerRect, fill);
    canvas.drawOval(outerRect, stroke);

    // Inner circle
    final innerRect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: innerRadius * 2,
      height: innerRadius * 1.6,
    );
    canvas.drawOval(innerRect, stroke);
  }

  void _drawFlatSpiral(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxRadius = 32.0;

    // Draw spiral as concentric arcs
    for (int i = 0; i < 5; i++) {
      double radius = maxRadius - (i * 6);
      if (radius < 6) break;

      double startAngle = 0.5 + (i * 0.6);
      double sweepAngle = 5.5;

      Rect spiralRect = Rect.fromCenter(
        center: Offset(cx, cy),
        width: radius * 2,
        height: radius * 2,
      );
      canvas.drawArc(spiralRect, startAngle, sweepAngle, false, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _CoilGeometryPainter oldDelegate) {
    return oldDelegate.type != type;
  }
}
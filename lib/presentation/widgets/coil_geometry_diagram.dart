import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

enum CoilGeometryType { singleLayer, multiLayer, flatSpiral }

class CoilGeometryDiagram extends StatelessWidget {
  final CoilGeometryType type;

  const CoilGeometryDiagram({super.key, required this.type});

  String get _label {
    switch (type) {
      case CoilGeometryType.singleLayer:
        return 'SINGLE LAYER';
      case CoilGeometryType.multiLayer:
        return 'MULTI LAYER';
      case CoilGeometryType.flatSpiral:
        return 'FLAT SPIRAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 100,
            child: CustomPaint(
              painter: _CoilGeometryPainter(type: type),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.backgroundSurface,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              _label,
              style: AppTheme.labelStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoilGeometryPainter extends CustomPainter {
  final CoilGeometryType type;

  _CoilGeometryPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = AppTheme.accentElectric
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = AppTheme.accentElectric.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    final dimPaint = Paint()
      ..color = AppTheme.textMuted
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75;

    final dimTextStyle = TextStyle(
      color: AppTheme.textMuted,
      fontSize: 9,
      fontWeight: FontWeight.w500,
    );

    switch (type) {
      case CoilGeometryType.singleLayer:
        _drawSingleLayer(canvas, size, strokePaint, fillPaint, dimPaint, dimTextStyle);
        break;
      case CoilGeometryType.multiLayer:
        _drawMultiLayer(canvas, size, strokePaint, fillPaint, dimPaint, dimTextStyle);
        break;
      case CoilGeometryType.flatSpiral:
        _drawFlatSpiral(canvas, size, strokePaint, fillPaint, dimPaint, dimTextStyle);
        break;
    }
  }

  void _drawSingleLayer(Canvas canvas, Size size, Paint stroke, Paint fill, Paint dim, TextStyle textStyle) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final coilWidth = 100.0;
    final coilHeight = 50.0;

    // Connection wires
    final wirePaint = Paint()
      ..color = const Color(0xFF9EAFC2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(10, cy), Offset(cx - coilWidth / 2 - 10, cy), wirePaint);
    canvas.drawLine(Offset(cx + coilWidth / 2 + 10, cy), Offset(size.width - 10, cy), wirePaint);

    // Draw coil loops
    final loopPaint = Paint()
      ..color = AppTheme.accentElectric
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 7; i++) {
      double xOffset = (i - 3) * 14;
      final loopRect = Rect.fromCenter(
        center: Offset(cx + xOffset, cy),
        width: 10,
        height: coilHeight,
      );
      canvas.drawArc(loopRect, -3.14159 / 2, 3.14159, false, loopPaint);
    }

    // Dimension lines - diameter D
    final dY = cy - coilHeight / 2 - 12;
    canvas.drawLine(Offset(cx - coilWidth / 2, dY), Offset(cx + coilWidth / 2, dY), dim);
    canvas.drawLine(Offset(cx - coilWidth / 2, dY - 3), Offset(cx - coilWidth / 2, dY + 3), dim);
    canvas.drawLine(Offset(cx + coilWidth / 2, dY - 3), Offset(cx + coilWidth / 2, dY + 3), dim);

    // Dimension lines - length L
    final lX = cx + coilWidth / 2 + 8;
    canvas.drawLine(Offset(lX, cy - coilHeight / 2), Offset(lX, cy + coilHeight / 2), dim);
    canvas.drawLine(Offset(lX - 3, cy - coilHeight / 2), Offset(lX + 3, cy - coilHeight / 2), dim);
    canvas.drawLine(Offset(lX - 3, cy + coilHeight / 2), Offset(lX + 3, cy + coilHeight / 2), dim);
  }

  void _drawMultiLayer(Canvas canvas, Size size, Paint stroke, Paint fill, Paint dim, TextStyle textStyle) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerRadius = 35.0;
    final innerRadius = 18.0;

    // Draw outer ellipse
    final outerRect = Rect.fromCenter(center: Offset(cx, cy), width: outerRadius * 2, height: outerRadius * 1.6);
    canvas.drawOval(outerRect, fill);
    canvas.drawOval(outerRect, stroke);

    // Draw inner ellipse
    final innerRect = Rect.fromCenter(center: Offset(cx, cy), width: innerRadius * 2, height: innerRadius * 1.6);
    canvas.drawOval(innerRect, stroke);

    // Cross-hatch pattern for layers
    final hatchPaint = Paint()
      ..color = AppTheme.accentElectric.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (double r = innerRadius + 5; r < outerRadius; r += 6) {
      final hatchRect = Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 1.6);
      canvas.drawOval(hatchRect, hatchPaint);
    }

    // Dimension lines
    final dY = cy - outerRadius - 10;
    canvas.drawLine(Offset(cx - outerRadius, dY), Offset(cx + outerRadius, dY), dim);
    canvas.drawLine(Offset(cx - outerRadius, dY - 3), Offset(cx - outerRadius, dY + 3), dim);
    canvas.drawLine(Offset(cx + outerRadius, dY - 3), Offset(cx + outerRadius, dY + 3), dim);

    final innerX = cx + innerRadius + 6;
    canvas.drawLine(Offset(innerX, cy - innerRadius), Offset(innerX, cy + innerRadius), dim);
  }

  void _drawFlatSpiral(Canvas canvas, Size size, Paint stroke, Paint fill, Paint dim, TextStyle textStyle) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxRadius = 36.0;

    // Draw spiral arcs
    for (int i = 0; i < 6; i++) {
      double radius = maxRadius - (i * 5.5);
      if (radius < 5) break;

      final spiralRect = Rect.fromCenter(center: Offset(cx, cy), width: radius * 2, height: radius * 2);
      double startAngle = 0.3 + (i * 0.5);
      double sweepAngle = 5.5 - (i * 0.15);

      final arcPaint = Paint()
        ..color = AppTheme.accentElectric
        ..style = PaintingStyle.stroke
        ..strokeWidth = i == 0 ? 2.5 : 1.5
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(spiralRect, startAngle, sweepAngle, false, arcPaint);
    }

    // Center point
    canvas.drawCircle(Offset(cx, cy), 2, Paint()..color = AppTheme.accentElectric);

    // Dimension line for outer diameter
    final dY = cy - maxRadius - 8;
    canvas.drawLine(Offset(cx - maxRadius, dY), Offset(cx + maxRadius, dY), dim);
    canvas.drawLine(Offset(cx - maxRadius, dY - 3), Offset(cx - maxRadius, dY + 3), dim);
    canvas.drawLine(Offset(cx + maxRadius, dY - 3), Offset(cx + maxRadius, dY + 3), dim);

    // Trace width indicator
    canvas.drawLine(
      Offset(cx - 8, cy - 4),
      Offset(cx - 8, cy + 4),
      Paint()
        ..color = AppTheme.textMuted
        ..strokeWidth = 0.75
        ..style = PaintingStyle.stroke,
    );
    canvas.drawLine(
      Offset(cx - 3.5, cy - 4),
      Offset(cx - 3.5, cy + 4),
      Paint()
        ..color = AppTheme.textMuted
        ..strokeWidth = 0.75
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _CoilGeometryPainter oldDelegate) => oldDelegate.type != type;
}
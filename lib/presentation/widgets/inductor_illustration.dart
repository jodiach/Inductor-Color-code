import 'package:flutter/material.dart';

class InductorIllustration extends StatelessWidget {
  final List<Color> bands;

  const InductorIllustration({super.key, required this.bands});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 80,
      child: CustomPaint(
        painter: _InductorPainter(bands: bands),
      ),
    );
  }
}

class _InductorPainter extends CustomPainter {
  final List<Color> bands;

  _InductorPainter({required this.bands});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2C2C3E) // Body color
      ..style = PaintingStyle.fill;

    final wirePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw wires
    canvas.drawLine(Offset(0, size.height / 2), Offset(20, size.height / 2), wirePaint);
    canvas.drawLine(Offset(size.width - 20, size.height / 2), Offset(size.width, size.height / 2), wirePaint);

    // Draw body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(20, 10, size.width - 40, size.height - 20),
      const Radius.circular(10),
    );
    canvas.drawRRect(bodyRect, paint);

    // Draw bands
    double bandWidth = (size.width - 60) / 10;
    double startX = 35;

    for (int i = 0; i < bands.length; i++) {
      final bandPaint = Paint()
        ..color = bands[i]
        ..style = PaintingStyle.fill;

      // Position bands
      double x = startX + (i * (bandWidth + 10));
      if (i == bands.length - 1) {
        // Last band (tolerance) is usually further apart
        x = size.width - 45;
      }

      canvas.drawRect(
        Rect.fromLTWH(x, 10, bandWidth, size.height - 20),
        bandPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _InductorPainter oldDelegate) {
    return oldDelegate.bands != bands;
  }
}

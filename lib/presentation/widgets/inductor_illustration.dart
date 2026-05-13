import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class InductorIllustration extends StatelessWidget {
  final List<Color> bands;

  const InductorIllustration({super.key, required this.bands});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundCard : AppTheme.lightBackgroundCard,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 240,
            height: 100,
            child: CustomPaint(
              painter: _InductorPainter(bands: bands, isDark: isDark),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.backgroundSurface : AppTheme.lightBackgroundSurface,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              'COLOR CODE',
              style: AppTheme.labelStyle.copyWith(
                color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InductorPainter extends CustomPainter {
  final List<Color> bands;
  final bool isDark;

  _InductorPainter({required this.bands, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final gridColor = isDark ? AppTheme.gridLine : AppTheme.lightGridLine;
    final borderColor = isDark ? AppTheme.borderActive : AppTheme.lightBorderActive;
    final bodyTop = const Color(0xFF2A3441);
    final bodyBottom = const Color(0xFF1A222D);
    final lightBodyTop = const Color(0xFFE8ECF0);
    final lightBodyBottom = const Color(0xFFD0D8E4);

    // Grid background
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 12) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 12) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Body gradient
    final bodyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark ? [bodyTop, bodyBottom] : [lightBodyTop, lightBodyBottom],
    );

    final bodyPaint = Paint()
      ..shader = bodyGradient.createShader(Rect.fromLTWH(20, 15, size.width - 40, size.height - 30))
      ..style = PaintingStyle.fill;

    // Shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(24, 20, size.width - 40, size.height - 30),
        const Radius.circular(8),
      ),
      Paint()..color = Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
    );

    // Draw body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(20, 15, size.width - 40, size.height - 30),
      const Radius.circular(8),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // Body outline
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Wire paint
    final wireColor = isDark ? const Color(0xFF9EAFC2) : const Color(0xFF6B7A8A);
    final wirePaint = Paint()
      ..color = wireColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Left wire
    canvas.drawLine(Offset(0, size.height / 2), Offset(20, size.height / 2), wirePaint);
    // Right wire
    canvas.drawLine(Offset(size.width - 20, size.height / 2), Offset(size.width, size.height / 2), wirePaint);

    // Band positions
    final bandAreaWidth = size.width - 80;
    final bandWidth = 10.0;
    final spacing = (bandAreaWidth - (bandWidth * bands.length)) / (bands.length + 1);

    for (int i = 0; i < bands.length; i++) {
      final bandPaint = Paint()
        ..color = bands[i]
        ..style = PaintingStyle.fill;

      // Band shadow
      canvas.drawRect(
        Rect.fromLTWH(
          30 + spacing + (i * (bandWidth + spacing)) + 1,
          18,
          bandWidth,
          size.height - 36,
        ),
        Paint()..color = Colors.black.withValues(alpha: isDark ? 0.25 : 0.1),
      );

      // Band
      final x = 30 + spacing + (i * (bandWidth + spacing));
      final bandRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, 15, bandWidth, size.height - 30),
        const Radius.circular(2),
      );
      canvas.drawRRect(bandRect, bandPaint);

      // Band shine
      canvas.drawRect(
        Rect.fromLTWH(x + 1, 16, 2, 6),
        Paint()..color = Colors.white.withValues(alpha: isDark ? 0.2 : 0.4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _InductorPainter oldDelegate) {
    return oldDelegate.bands != bands || oldDelegate.isDark != isDark;
  }
}
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/unit_converter.dart';

class ValueDisplay extends StatelessWidget {
  final double? value;
  final double? tolerance;

  const ValueDisplay({
    super.key,
    required this.value,
    this.tolerance,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundCard : AppTheme.lightBackgroundCard,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? AppTheme.borderActive : AppTheme.lightBorderActive,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentNeon.withValues(alpha: 0.08),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value != null ? UnitConverter.formatInductance(value!) : '--',
                style: AppTheme.technicalValue.copyWith(
                  color: value != null
                      ? (isDark ? AppTheme.accentNeon : AppTheme.lightTextPrimary)
                      : (isDark ? AppTheme.textMuted : AppTheme.lightTextMuted),
                ),
              ),
            ],
          ),
          if (tolerance != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.backgroundSurface : AppTheme.lightBackgroundSurface,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
                  width: 1,
                ),
              ),
              child: Text(
                'TOLERANCE ±${tolerance!.toStringAsFixed(1)}%',
                style: AppTheme.labelStyle.copyWith(
                  color: AppTheme.accentElectric,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

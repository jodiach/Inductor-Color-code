import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/unit_converter.dart';

class ValueDisplay extends StatelessWidget {
  final double value;
  final double? tolerance;

  const ValueDisplay({
    super.key,
    required this.value,
    this.tolerance,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          UnitConverter.formatInductance(value),
          style: AppTheme.technicalValue.copyWith(fontSize: 40),
        ),
        if (tolerance != null)
          Text(
            '±${tolerance!.toStringAsFixed(1)}%',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 18,
            ),
          ),
      ],
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import '../entities/inductor.dart';
import '../../core/constants/color_codes.dart';

class ValueToColor {
  /// Convert inductance value to nearest E-series value and return band colors
  /// Returns Inductor with bands for 4-band or 5-band display
  static Inductor calculate(double valueInMicroHenry, double tolerancePercent, bool useFiveBand) {
    // Find nearest E-series value
    double normalizedValue = valueInMicroHenry;
    int powerOfTen = 0;

    // Normalize to 1-100 range for E-series
    while (normalizedValue < 1) {
      normalizedValue *= 10;
      powerOfTen--;
    }
    while (normalizedValue >= 100) {
      normalizedValue /= 10;
      powerOfTen++;
    }

    // E12 series values
    const List<double> e12Series = [10, 12, 15, 18, 22, 27, 33, 39, 47, 56, 68, 82];

    // Find closest E12 value
    double closestValue = e12Series[0];
    double minDiff = (normalizedValue - e12Series[0]).abs();

    for (double val in e12Series) {
      double diff = (normalizedValue - val).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestValue = val;
      }
    }

    // Convert back to actual value
    double actualValue = closestValue * pow(10, powerOfTen);

    // Extract digits for bands
    List<int> digits;
    int multiplierIndex;

    if (useFiveBand) {
      // 5-band: 3 significant digits
      String valStr = closestValue.toStringAsFixed(0).padLeft(3, '0');
      digits = [
        int.parse(valStr[0]),
        int.parse(valStr[1]),
        int.parse(valStr[2]),
      ];
      multiplierIndex = powerOfTen;
    } else {
      // 4-band: 2 significant digits
      String valStr = closestValue.toStringAsFixed(0).padLeft(2, '0');
      digits = [
        int.parse(valStr[0]),
        int.parse(valStr[1]),
      ];
      multiplierIndex = powerOfTen;
    }

    // Clamp multiplier index to valid range
    if (multiplierIndex < -2) multiplierIndex = -2;
    if (multiplierIndex > 9) multiplierIndex = 9;

    // Build band colors
    List<Color> bands = [];
    for (int digit in digits) {
      bands.add(InductorColorCodes.digitColors[digit]!);
    }

    // Add multiplier color
    if (multiplierIndex >= 0 && multiplierIndex <= 9) {
      bands.add(InductorColorCodes.multiplierColors[multiplierIndex]!);
    } else if (multiplierIndex == -1) {
      bands.add(InductorColorCodes.multiplierColors[-1]!); // Gold
    } else {
      bands.add(InductorColorCodes.multiplierColors[-2]!); // Silver
    }

    // Add tolerance color
    Color tolColor = InductorColorCodes.toleranceColors[tolerancePercent] ?? Colors.transparent;
    if (tolColor != Colors.transparent) {
      bands.add(tolColor);
    }

    return Inductor(
      bands: bands,
      value: actualValue,
      tolerance: tolerancePercent,
    );
  }
}

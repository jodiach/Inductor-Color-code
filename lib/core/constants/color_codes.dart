import 'package:flutter/material.dart';

class InductorColorCodes {
  static const Map<int, Color> digitColors = {
    0: Color(0xFF000000), // Black
    1: Color(0xFF8B4513), // Brown
    2: Color(0xFFFF0000), // Red
    3: Color(0xFFFF8C00), // Orange
    4: Color(0xFFFFFF00), // Yellow
    5: Color(0xFF008000), // Green
    6: Color(0xFF0000FF), // Blue
    7: Color(0xFFEE82EE), // Violet
    8: Color(0xFF808080), // Gray
    9: Color(0xFFFFFFFF), // White
  };

  static const Map<int, Color> multiplierColors = {
    0: Color(0xFF000000), // x1 (Black)
    1: Color(0xFF8B4513), // x10 (Brown)
    2: Color(0xFFFF0000), // x100 (Red)
    3: Color(0xFFFF8C00), // x1k (Orange)
    4: Color(0xFFFFFF00), // x10k (Yellow)
    5: Color(0xFF008000), // x100k (Green)
    6: Color(0xFF0000FF), // x1M (Blue)
    7: Color(0xFFEE82EE), // x10M (Violet)
    8: Color(0xFF808080), // x100M (Gray)
    9: Color(0xFFFFFFFF), // x1G (White)
    -1: Color(0xFFFFD700), // x0.1 (Gold)
    -2: Color(0xFFC0C0C0), // x0.01 (Silver)
  };

  static final Map<double, Color> toleranceColors = {
    20.0: Colors.transparent, // No band
    1.0: const Color(0xFF8B4513), // Brown
    2.0: const Color(0xFFFF0000), // Red
    3.0: const Color(0xFFFF8C00), // Orange
    4.0: const Color(0xFFFFFF00), // Yellow
    0.5: const Color(0xFF008000), // Green
    0.25: const Color(0xFF0000FF), // Blue
    0.1: const Color(0xFFEE82EE), // Violet
    0.05: const Color(0xFF808080), // Gray
    5.0: const Color(0xFFFFD700), // Gold
    10.0: const Color(0xFFC0C0C0), // Silver
  };

  static const List<double> multipliers = [
    1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, 0.1, 0.01
  ];
}

import 'package:flutter/material.dart';

class Inductor {
  final List<Color> bands;
  final double value; // in µH
  final double tolerance; // percentage

  Inductor({
    required this.bands,
    required this.value,
    required this.tolerance,
  });

  double get minRange => value * (1 - tolerance / 100);
  double get maxRange => value * (1 + tolerance / 100);
}

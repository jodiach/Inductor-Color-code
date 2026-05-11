import 'dart:math';

class SingleLayerCoil {
  /// Wheeler's formula for single-layer solenoid
  /// d: diameter in mm
  /// l: length in mm
  /// n: number of turns
  /// Returns inductance in µH
  static double calculate(double d, double l, int n) {
    if (d <= 0 || l <= 0 || n <= 0) return 0;
    
    // L (µH) = (d^2 * n^2) / (457.2*d + 1016*l)
    double numerator = pow(d, 2).toDouble() * pow(n, 2).toDouble();
    double denominator = (457.2 * d) + (1016 * l);
    
    return (numerator / denominator).toDouble();
  }
}

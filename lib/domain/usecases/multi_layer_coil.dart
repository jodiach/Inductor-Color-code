import 'dart:math';

class MultiLayerCoil {
  /// Simplified multilayer formula
  /// d_inner: inner diameter in mm
  /// d_outer: outer diameter in mm
  /// l: winding length in mm
  /// n: number of turns
  /// Returns inductance in µH
  static double calculate(double dInner, double dOuter, double l, int n) {
    if (dInner <= 0 || dOuter <= dInner || l <= 0 || n <= 0) return 0;

    double rMean = (dInner + dOuter) / 4.0;
    double b = (dOuter - dInner) / 2.0;

    // L (µH) = (0.315 * rMean^2 * n^2) / (25.4 * (6*rMean + 9*l + 10*b))
    double numerator = 0.315 * pow(rMean, 2).toDouble() * pow(n, 2).toDouble();
    double denominator = 25.4 * (6 * rMean + 9 * l + 10 * b);

    return (numerator / denominator).toDouble();
  }
}

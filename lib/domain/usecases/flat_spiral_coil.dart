import 'dart:math';

class FlatSpiralCoil {
  /// Mongef's/Wheeler's formula for flat spiral
  /// d_outer: outer diameter in mm
  /// w: trace width in mm
  /// s: trace spacing in mm
  /// n: number of turns
  /// Returns inductance in µH
  static double calculate(double dOuter, double w, double s, int n) {
    if (dOuter <= 0 || n <= 0) return 0;

    // Total width of winding = n * w + (n-1) * s
    double totalWindingWidth = (n * w) + ((n - 1) * s);
    double dInner = dOuter - (2 * totalWindingWidth);
    
    if (dInner < 0) dInner = 0;

    double rMean = (dOuter + dInner) / 4.0;
    double windingWidth = (dOuter - dInner) / 2.0;

    // L (µH) = (rMean^2 * n^2) / (25.4 * (8*rMean + 11*windingWidth))
    double numerator = pow(rMean, 2).toDouble() * pow(n, 2).toDouble();
    double denominator = 25.4 * (8 * rMean + 11 * windingWidth);

    return (numerator / denominator).toDouble();
  }
}

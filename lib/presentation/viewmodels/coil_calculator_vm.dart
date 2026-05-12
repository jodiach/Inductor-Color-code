import 'package:flutter/material.dart';
import '../../domain/usecases/single_layer_coil.dart';
import '../../domain/usecases/multi_layer_coil.dart';
import '../../domain/usecases/flat_spiral_coil.dart';

enum CoilType { singleLayer, multiLayer, flatSpiral }

class CoilCalculatorViewModel extends ChangeNotifier {
  CoilType _activeType = CoilType.singleLayer;
  CoilType get activeType => _activeType;

  // Single Layer Inputs
  double d = 0.0;
  double l = 0.0;
  int n = 0;

  // Multi Layer Inputs
  double dInner = 0.0;
  double dOuter = 0.0;
  double lMulti = 0.0;
  int nMulti = 0;

  // Flat Spiral Inputs
  double dOuterSpiral = 0.0;
  double w = 0.0;
  double s = 0.0;
  int nSpiral = 0;

  void setType(CoilType type) {
    _activeType = type;
    notifyListeners();
  }

  double? get inductance {
    switch (_activeType) {
      case CoilType.singleLayer:
        if (d <= 0 || l <= 0 || n <= 0) return null;
        return SingleLayerCoil.calculate(d, l, n);
      case CoilType.multiLayer:
        if (dInner <= 0 || dOuter <= 0 || lMulti <= 0 || nMulti <= 0) return null;
        return MultiLayerCoil.calculate(dInner, dOuter, lMulti, nMulti);
      case CoilType.flatSpiral:
        if (dOuterSpiral <= 0 || w <= 0 || s <= 0 || nSpiral <= 0) return null;
        return FlatSpiralCoil.calculate(dOuterSpiral, w, s, nSpiral);
    }
  }

  void updateSingleLayer(double? d, double? l, int? n) {
    if (d != null) this.d = d;
    if (l != null) this.l = l;
    if (n != null) this.n = n;
    notifyListeners();
  }

  void updateMultiLayer(double? di, double? do_, double? l, int? n) {
    if (di != null) this.dInner = di;
    if (do_ != null) this.dOuter = do_;
    if (l != null) this.lMulti = l;
    if (n != null) this.nMulti = n;
    notifyListeners();
  }

  void updateFlatSpiral(double? do_, double? w, double? s, int? n) {
    if (do_ != null) this.dOuterSpiral = do_;
    if (w != null) this.w = w;
    if (s != null) this.s = s;
    if (n != null) this.nSpiral = n;
    notifyListeners();
  }
}

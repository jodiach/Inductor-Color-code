import 'package:flutter/material.dart';
import '../../domain/usecases/single_layer_coil.dart';
import '../../domain/usecases/multi_layer_coil.dart';
import '../../domain/usecases/flat_spiral_coil.dart';

enum CoilType { singleLayer, multiLayer, flatSpiral }

class CoilCalculatorViewModel extends ChangeNotifier {
  CoilType _activeType = CoilType.singleLayer;
  CoilType get activeType => _activeType;

  // Single Layer Inputs
  double d = 10.0;
  double l = 20.0;
  int n = 50;

  // Multi Layer Inputs
  double dInner = 10.0;
  double dOuter = 20.0;
  double lMulti = 10.0;
  int nMulti = 100;

  // Flat Spiral Inputs
  double dOuterSpiral = 30.0;
  double w = 0.5;
  double s = 0.5;
  int nSpiral = 10;

  void setType(CoilType type) {
    _activeType = type;
    notifyListeners();
  }

  double get inductance {
    switch (_activeType) {
      case CoilType.singleLayer:
        return SingleLayerCoil.calculate(d, l, n);
      case CoilType.multiLayer:
        return MultiLayerCoil.calculate(dInner, dOuter, lMulti, nMulti);
      case CoilType.flatSpiral:
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

import 'package:flutter/material.dart';
import '../../domain/usecases/single_layer_coil.dart';
import '../../domain/usecases/multi_layer_coil.dart';
import '../../domain/usecases/flat_spiral_coil.dart';
import 'history_vm.dart';

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

  // Validation errors
  String? dError;
  String? lError;
  String? nError;
  String? dInnerError;
  String? dOuterError;
  String? lMultiError;
  String? nMultiError;
  String? dSpiralError;
  String? wError;
  String? sError;
  String? nSpiralError;

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

  void _clearErrors() {
    dError = null;
    lError = null;
    nError = null;
    dInnerError = null;
    dOuterError = null;
    lMultiError = null;
    nMultiError = null;
    dSpiralError = null;
    wError = null;
    sError = null;
    nSpiralError = null;
  }

  void updateSingleLayer(double? dVal, double? lVal, int? nVal) {
    _clearErrors();
    if (dVal != null) {
      if (dVal < 0) {
        dError = 'Must be >= 0';
      } else {
        d = dVal;
      }
    }
    if (lVal != null) {
      if (lVal < 0) {
        lError = 'Must be >= 0';
      } else {
        l = lVal;
      }
    }
    if (nVal != null) {
      if (nVal < 0) {
        nError = 'Must be >= 0';
      } else {
        n = nVal;
      }
    }
    notifyListeners();
  }

  void updateMultiLayer(double? di, double? do_, double? l, int? n) {
    _clearErrors();
    if (di != null) {
      if (di < 0) {
        dInnerError = 'Must be >= 0';
      } else {
        dInner = di;
      }
    }
    if (do_ != null) {
      if (do_ < 0) {
        dOuterError = 'Must be >= 0';
      } else {
        dOuter = do_;
      }
    }
    if (l != null) {
      if (l < 0) {
        lMultiError = 'Must be >= 0';
      } else {
        lMulti = l;
      }
    }
    if (n != null) {
      if (n < 0) {
        nMultiError = 'Must be >= 0';
      } else {
        nMulti = n;
      }
    }
    notifyListeners();
  }

  void updateFlatSpiral(double? do_, double? wVal, double? sVal, int? nVal) {
    _clearErrors();
    if (do_ != null) {
      if (do_ < 0) {
        dSpiralError = 'Must be >= 0';
      } else {
        dOuterSpiral = do_;
      }
    }
    if (wVal != null) {
      if (wVal < 0) {
        wError = 'Must be >= 0';
      } else {
        w = wVal;
      }
    }
    if (sVal != null) {
      if (sVal < 0) {
        sError = 'Must be >= 0';
      } else {
        s = sVal;
      }
    }
    if (nVal != null) {
      if (nVal < 0) {
        nSpiralError = 'Must be >= 0';
      } else {
        nSpiral = nVal;
      }
    }
    notifyListeners();
  }

  void loadFromHistory(Map<String, dynamic> inputs) {
    _clearErrors();
    if (inputs.containsKey('d')) {
      d = (inputs['d'] as num?)?.toDouble() ?? 0.0;
    }
    if (inputs.containsKey('l')) {
      l = (inputs['l'] as num?)?.toDouble() ?? 0.0;
    }
    if (inputs.containsKey('n')) {
      n = (inputs['n'] as num?)?.toInt() ?? 0;
    }
    if (inputs.containsKey('dInner')) {
      dInner = (inputs['dInner'] as num?)?.toDouble() ?? 0.0;
    }
    if (inputs.containsKey('dOuter')) {
      dOuter = (inputs['dOuter'] as num?)?.toDouble() ?? 0.0;
    }
    if (inputs.containsKey('lMulti')) {
      lMulti = (inputs['lMulti'] as num?)?.toDouble() ?? 0.0;
    }
    if (inputs.containsKey('nMulti')) {
      nMulti = (inputs['nMulti'] as num?)?.toInt() ?? 0;
    }
    if (inputs.containsKey('dOuterSpiral')) {
      dOuterSpiral = (inputs['dOuterSpiral'] as num?)?.toDouble() ?? 0.0;
    }
    if (inputs.containsKey('w')) {
      w = (inputs['w'] as num?)?.toDouble() ?? 0.0;
    }
    if (inputs.containsKey('s')) {
      s = (inputs['s'] as num?)?.toDouble() ?? 0.0;
    }
    if (inputs.containsKey('nSpiral')) {
      nSpiral = (inputs['nSpiral'] as num?)?.toInt() ?? 0;
    }
    notifyListeners();
  }

  void setActiveTypeAndLoad(CalculationType type, Map<String, dynamic> inputs) {
    switch (type) {
      case CalculationType.coilSingle:
        _activeType = CoilType.singleLayer;
        loadFromHistory(inputs);
        break;
      case CalculationType.coilMulti:
        _activeType = CoilType.multiLayer;
        loadFromHistory(inputs);
        break;
      case CalculationType.coilFlatSpiral:
        _activeType = CoilType.flatSpiral;
        loadFromHistory(inputs);
        break;
      default:
        break;
    }
    notifyListeners();
  }
}

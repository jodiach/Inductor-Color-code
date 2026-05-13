import 'package:flutter/material.dart';
import 'dart:math' as math;

enum SteelCoilMode { weight, unwind }

class SteelCoilResult {
  final Map<String, String> values;

  SteelCoilResult(this.values);

  String get(String key) => values[key] ?? '';
}

class SteelCoilViewModel extends ChangeNotifier {
  SteelCoilMode _mode = SteelCoilMode.weight;
  bool _isLoading = false;

  // Weight inputs
  double _innerDiameter = 0.0;
  double _outerDiameter = 0.0;
  double _width = 0.0;
  double _density = 0.284;        // lb/in³ (carbon steel)

  // Unwind inputs
  double _thickness = 0.0;
  double _stripWidth = 0.0;

  // Validation errors
  String? innerDiameterError;
  String? outerDiameterError;
  String? widthError;
  String? densityError;
  String? thicknessError;
  String? stripWidthError;

  // Results
  SteelCoilResult? _weightResult;
  SteelCoilResult? _unwindResult;

  SteelCoilMode get mode => _mode;
  bool get isLoading => _isLoading;
  double get innerDiameter => _innerDiameter;
  double get outerDiameter => _outerDiameter;
  double get width => _width;
  double get density => _density;
  double get thickness => _thickness;
  double get stripWidth => _stripWidth;
  SteelCoilResult? get weightResult => _weightResult;
  SteelCoilResult? get unwindResult => _unwindResult;

  void setMode(SteelCoilMode mode) {
    _mode = mode;
    notifyListeners();
  }

  void _clearErrors() {
    innerDiameterError = null;
    outerDiameterError = null;
    widthError = null;
    densityError = null;
    thicknessError = null;
    stripWidthError = null;
  }

  void setInnerDiameter(double v) {
    _clearErrors();
    if (v < 0) {
      innerDiameterError = 'Must be >= 0';
    } else {
      _innerDiameter = v;
    }
    _compute();
  }

  void setOuterDiameter(double v) {
    _clearErrors();
    if (v < 0) {
      outerDiameterError = 'Must be >= 0';
    } else {
      _outerDiameter = v;
    }
    _compute();
  }

  void setWidth(double v) {
    _clearErrors();
    if (v < 0) {
      widthError = 'Must be >= 0';
    } else {
      _width = v;
    }
    _compute();
  }

  void setDensity(double v) {
    _clearErrors();
    if (v < 0) {
      densityError = 'Must be >= 0';
    } else {
      _density = v;
    }
    _compute();
  }

  void setThickness(double v) {
    _clearErrors();
    if (v < 0) {
      thicknessError = 'Must be >= 0';
    } else {
      _thickness = v;
    }
    _compute();
  }

  void setStripWidth(double v) {
    _clearErrors();
    if (v < 0) {
      stripWidthError = 'Must be >= 0';
    } else {
      _stripWidth = v;
    }
    _compute();
  }

  void _compute() {
    _computeWeight();
    _computeUnwind();
    notifyListeners();
  }

  void _computeWeight() {
    if (_outerDiameter <= _innerDiameter || _outerDiameter <= 0 || _width <= 0) {
      _weightResult = null;
      return;
    }

    // Volume = π * W * (OD² - ID²) / 4
    final volume = math.pi * _width * (math.pow(_outerDiameter, 2) - math.pow(_innerDiameter, 2)) / 4.0;
    final weightLbs = volume * _density;
    final weightPerInch = _density * math.pi * (math.pow(_outerDiameter, 2) - math.pow(_innerDiameter, 2)) / 4.0;

    _weightResult = SteelCoilResult({
      'totalWeight': _formatWeight(weightLbs),
      'weightPerInch': _formatWeight(weightPerInch),
      'totalWeightLbs': weightLbs.toStringAsFixed(2),
      'weightPerInchLbs': weightPerInch.toStringAsFixed(4),
    });
  }

  void _computeUnwind() {
    if (_outerDiameter <= _innerDiameter || _outerDiameter <= 0 || _thickness <= 0 || _stripWidth <= 0) {
      _unwindResult = null;
      return;
    }

    // Lineal feet = π * (OD² - ID²) / (4 * t)
    final linealInches = math.pi * (math.pow(_outerDiameter, 2) - math.pow(_innerDiameter, 2)) / (4.0 * _thickness);
    final linealFeet = linealInches / 12.0;

    // Feet per layer
    final avgDiameter = (_outerDiameter + _innerDiameter) / 2.0;
    final feetPerLayer = math.pi * avgDiameter / _thickness / 12.0;

    // Sheets per coil (at stripWidth)
    final coilArea = math.pi * (math.pow(_outerDiameter, 2) - math.pow(_innerDiameter, 2)) / 4.0;
    final stripAreaSqIn = _stripWidth * _thickness;
    final sheetsPerCoil = coilArea / stripAreaSqIn;

    _unwindResult = SteelCoilResult({
      'linealFeet': linealFeet.toStringAsFixed(1),
      'feetPerLayer': feetPerLayer.toStringAsFixed(2),
      'sheetsPerCoil': sheetsPerCoil.toStringAsFixed(1),
      'linealFeetRaw': linealFeet.toStringAsFixed(2),
    });
  }

  String _formatWeight(double lbs) {
    if (lbs >= 2000) {
      return '${(lbs / 2000).toStringAsFixed(2)} tons';
    }
    return '${lbs.toStringAsFixed(2)} lbs';
  }

  Map<String, dynamic> toHistoryInputs() {
    if (_mode == SteelCoilMode.weight) {
      return {
        'innerDiameter': _innerDiameter,
        'outerDiameter': _outerDiameter,
        'width': _width,
        'density': _density,
      };
    } else {
      return {
        'innerDiameter': _innerDiameter,
        'outerDiameter': _outerDiameter,
        'thickness': _thickness,
        'stripWidth': _stripWidth,
      };
    }
  }

  Map<String, dynamic> toHistoryResult() {
    if (_mode == SteelCoilMode.weight && _weightResult != null) {
      return {
        'totalWeight': _weightResult!.get('totalWeight'),
        'weightPerInch': _weightResult!.get('weightPerInch'),
      };
    } else if (_mode == SteelCoilMode.unwind && _unwindResult != null) {
      return {
        'linealFeet': _unwindResult!.get('linealFeet'),
        'sheetsPerCoil': _unwindResult!.get('sheetsPerCoil'),
      };
    }
    return {};
  }

  void loadFromHistory(Map<String, dynamic> inputs) {
    _clearErrors();
    if (inputs.containsKey('innerDiameter')) {
      _innerDiameter = (inputs['innerDiameter'] as num?)?.toDouble() ?? 0.0;
    }
    if (inputs.containsKey('outerDiameter')) {
      _outerDiameter = (inputs['outerDiameter'] as num?)?.toDouble() ?? 0.0;
    }
    if (inputs.containsKey('width')) {
      _width = (inputs['width'] as num?)?.toDouble() ?? 0.0;
    }
    if (inputs.containsKey('density')) {
      _density = (inputs['density'] as num?)?.toDouble() ?? 0.284;
    }
    if (inputs.containsKey('thickness')) {
      _thickness = (inputs['thickness'] as num?)?.toDouble() ?? 0.0;
    }
    if (inputs.containsKey('stripWidth')) {
      _stripWidth = (inputs['stripWidth'] as num?)?.toDouble() ?? 0.0;
    }
    _compute();
    notifyListeners();
  }

  void setModeAndLoad(SteelCoilMode mode, Map<String, dynamic> inputs) {
    _mode = mode;
    loadFromHistory(inputs);
  }
}

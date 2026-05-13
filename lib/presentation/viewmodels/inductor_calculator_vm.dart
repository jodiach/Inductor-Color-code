import 'package:flutter/material.dart';
import '../../core/constants/color_codes.dart';
import '../../domain/usecases/color_to_value.dart';

class InductorCalculatorViewModel extends ChangeNotifier {
  int _bandCount = 4;
  int get bandCount => _bandCount;

  List<int> _selectedDigits = [0, 0];
  int _selectedMultiplierIndex = 0;
  double _selectedTolerance = 20.0;

  List<int> get digits => _bandCount == 4 ? _selectedDigits : [..._selectedDigits, 0];

  void setBandCount(int count) {
    _bandCount = count;
    if (_bandCount == 5 && _selectedDigits.length == 2) {
      _selectedDigits.add(0);
    } else if (_bandCount == 4 && _selectedDigits.length == 3) {
      _selectedDigits.removeAt(2);
    }
    notifyListeners();
  }

  void setDigit(int index, int value) {
    if (index < _selectedDigits.length) {
      _selectedDigits[index] = value;
      notifyListeners();
    }
  }

  void setMultiplier(int index) {
    _selectedMultiplierIndex = index;
    notifyListeners();
  }

  bool isMultiplierSelected(int index) => _selectedMultiplierIndex == index;

  void setTolerance(double value) {
    _selectedTolerance = value;
    notifyListeners();
  }

  double get inductance {
    return ColorToValue.calculate(_selectedDigits, _getMultiplierValue());
  }

  double get tolerance => _selectedTolerance;
  double get multiplierValue => _getMultiplierValue();

  double _getMultiplierValue() {
    if (_selectedMultiplierIndex == 11) return 0.001;
    if (_selectedMultiplierIndex == 12) return 0.01;
    if (_selectedMultiplierIndex == 10) return 0.1;
    if (_selectedMultiplierIndex >= 0 && _selectedMultiplierIndex <= 9) {
      return InductorColorCodes.multipliers[_selectedMultiplierIndex];
    }
    return 1.0;
  }

  List<Color> get bandColors {
    List<Color> colors = [];
    for (int digit in _selectedDigits) {
      colors.add(InductorColorCodes.digitColors[digit]!);
    }

    // Multiplier color
    colors.add(_getMultiplierColor());

    // Tolerance color
    Color tolColor = InductorColorCodes.toleranceColors[_selectedTolerance]!;
    if (tolColor != Colors.transparent) {
      colors.add(tolColor);
    }

    return colors;
  }

  Color _getMultiplierColor() {
    if (_selectedMultiplierIndex == 11) return InductorColorCodes.multiplierColors[-3]!;
    if (_selectedMultiplierIndex == 12) return InductorColorCodes.multiplierColors[-2]!;
    if (_selectedMultiplierIndex == 10) return InductorColorCodes.multiplierColors[-1]!;
    if (_selectedMultiplierIndex >= 0 && _selectedMultiplierIndex <= 9) {
      return InductorColorCodes.multiplierColors[_selectedMultiplierIndex]!;
    }
    return InductorColorCodes.multiplierColors[0]!;
  }

  void loadFromHistory(Map<String, dynamic> inputs) {
    _bandCount = (inputs['bandCount'] ?? 4) as int;
    final bandCount = _bandCount;

    if (inputs.containsKey('digits')) {
      final digitsData = inputs['digits'];
      if (digitsData is List) {
        _selectedDigits = digitsData.map((e) => (e as num).toInt()).toList();
        if (bandCount == 4 && _selectedDigits.length > 2) {
          _selectedDigits = _selectedDigits.sublist(0, 2);
        } else if (bandCount == 5 && _selectedDigits.length < 3) {
          while (_selectedDigits.length < 3) _selectedDigits.add(0);
        }
      }
    }

    if (inputs.containsKey('multiplier')) {
      final multVal = (inputs['multiplier'] as num).toDouble();
      _selectedMultiplierIndex = _getMultiplierIndexFromValue(multVal);
    }

    if (inputs.containsKey('tolerance')) {
      _selectedTolerance = (inputs['tolerance'] as num).toDouble();
    }

    notifyListeners();
  }

  int _getMultiplierIndexFromValue(double value) {
    if (value == 0.001) return 11;
    if (value == 0.01) return 12;
    if (value == 0.1) return 10;
    final doubleVal = value.toDouble();
    for (int i = 0; i < InductorColorCodes.multipliers.length; i++) {
      if (InductorColorCodes.multipliers[i] == doubleVal) return i;
    }
    return 0;
  }
}

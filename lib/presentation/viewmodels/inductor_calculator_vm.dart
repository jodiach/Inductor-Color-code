import 'package:flutter/material.dart';
import '../../core/constants/color_codes.dart';
import '../../domain/usecases/color_to_value.dart';

class InductorCalculatorViewModel extends ChangeNotifier {
  int _bandCount = 4;
  int get bandCount => _bandCount;

  List<int> _selectedDigits = [1, 0]; // Default for 4-band: Brown, Black
  int _selectedMultiplierIndex = 0; // Black (x1)
  double _selectedTolerance = 20.0; // Default: No band (±20%)

  // For 5-band, we add one more digit
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

  void setTolerance(double value) {
    _selectedTolerance = value;
    notifyListeners();
  }

  double get inductance {
    double multiplierValue = _getMultiplierValue();
    return ColorToValue.calculate(_selectedDigits, multiplierValue);
  }

  double get tolerance => _selectedTolerance;

  double _getMultiplierValue() {
    // Mapping index to value
    if (_selectedMultiplierIndex >= 0 && _selectedMultiplierIndex <= 9) {
      return InductorColorCodes.multipliers[_selectedMultiplierIndex];
    } else if (_selectedMultiplierIndex == 10) {
      return 0.1; // Gold
    } else {
      return 0.01; // Silver
    }
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
    if (_selectedMultiplierIndex >= 0 && _selectedMultiplierIndex <= 9) {
      return InductorColorCodes.multiplierColors[_selectedMultiplierIndex]!;
    } else if (_selectedMultiplierIndex == 10) {
      return InductorColorCodes.multiplierColors[-1]!;
    } else {
      return InductorColorCodes.multiplierColors[-2]!;
    }
  }
}

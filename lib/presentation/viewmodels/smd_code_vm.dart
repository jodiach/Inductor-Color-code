import 'package:flutter/material.dart';

enum SmdCodeType { eia96, numeric, unknown }

class SmdCodeResult {
  final String code;
  final SmdCodeType type;
  final double valueUh;
  final String breakdown;
  final String unit;

  SmdCodeResult({
    required this.code,
    required this.type,
    required this.valueUh,
    required this.breakdown,
    this.unit = 'µH',
  });
}

class SmdCodeViewModel extends ChangeNotifier {
  String _inputCode = '';
  SmdCodeResult? _result;
  String? _error;

  String get inputCode => _inputCode;
  SmdCodeResult? get result => _result;
  String? get error => _error;

  // EIA-96 multiplier letters
  static const Map<String, double> eia96Multipliers = {
    'S': 0.01,
    'R': 0.1,
    'X': 1,
    'A': 10,
    'B': 100,
    'C': 1000,
    'D': 10000,
    'E': 100000,
  };

  // EIA-96 table (first two digits -> base value)
  static const List<int> eia96Table = [
    100, 102, 105, 107, 110, 113, 115, 118, 121, 124,
    127, 130, 133, 137, 140, 143, 147, 150, 154, 158,
    162, 165, 169, 174, 178, 182, 187, 191, 196, 200,
    205, 210, 216, 221, 226, 232, 237, 243, 249, 255,
    261, 267, 274, 280, 287, 294, 301, 309, 316, 324,
    332, 340, 348, 357, 365, 374, 383, 392, 402, 412,
    422, 432, 442, 453, 464, 475, 487, 499, 511, 523,
    536, 549, 562, 576, 590, 604, 619, 634, 649, 665,
    681, 698, 715, 732, 750, 768, 787, 806, 825, 845,
    866, 887, 909, 931, 953, 976,
  ];

  void parseCode(String code) {
    _inputCode = code.trim().toUpperCase();
    _error = null;
    _result = null;

    if (_inputCode.isEmpty) {
      notifyListeners();
      return;
    }

    // Check if it's EIA-96 (2 digits + 1 letter)
    if (_inputCode.length == 3) {
      final digits = _inputCode.substring(0, 2);
      final letter = _inputCode.substring(2);

      if (int.tryParse(digits) != null && eia96Multipliers.containsKey(letter)) {
        _parseEia96(digits, letter);
        notifyListeners();
        return;
      }
    }

    // Check if it's numeric 3-digit code
    if (_inputCode.length == 3 && int.tryParse(_inputCode) != null) {
      _parseNumeric(_inputCode);
      notifyListeners();
      return;
    }

    _error = 'Invalid SMD code format';
    notifyListeners();
  }

  void _parseEia96(String digits, String letter) {
    final index = int.parse(digits) - 1;
    if (index < 0 || index >= eia96Table.length) {
      _error = 'Invalid EIA-96 code';
      return;
    }

    final baseValue = eia96Table[index];
    final multiplier = eia96Multipliers[letter]!;
    final value = baseValue * multiplier;

    _result = SmdCodeResult(
      code: _inputCode,
      type: SmdCodeType.eia96,
      valueUh: value,
      breakdown: 'EIA-96: ${digits}[$letter] = $baseValue × ${multiplier}x = $value µH',
      unit: 'µH',
    );
  }

  void _parseNumeric(String code) {
    final significant = int.parse(code.substring(0, 2));
    final multiplierExp = int.parse(code.substring(2));

    // For inductors, numeric code typically in nH or pH
    // Common format: code in pF, last digit = multiplier (10^n)
    // e.g., "101" = 100pF base × 10^1 = 1000pF = 1µH (if nH) or 1nH (direct)
    final value = significant * (10 * multiplierExp);

    // Most SMD inductor numeric codes give values in nH
    // Convert to µH (divide by 1000)
    final valueUh = value / 1000.0;

    _result = SmdCodeResult(
      code: _inputCode,
      type: SmdCodeType.numeric,
      valueUh: valueUh,
      breakdown: 'Numeric: ${code[0]}${code[1]} × 10^${code[2]} = $value nH = ${valueUh.toStringAsFixed(2)} µH',
      unit: 'µH',
    );
  }

  void clear() {
    _inputCode = '';
    _result = null;
    _error = null;
    notifyListeners();
  }
}
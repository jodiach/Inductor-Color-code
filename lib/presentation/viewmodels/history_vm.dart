import 'package:flutter/material.dart';
import '../../../core/database/database_helper.dart';

enum CalculationType {
  inductorColor4('inductor_color_4', '4-Band Color Code'),
  inductorColor5('inductor_color_5', '5-Band Color Code'),
  coilSingle('coil_single', 'Single Layer Coil'),
  coilMulti('coil_multi', 'Multi Layer Coil'),
  coilFlatSpiral('coil_flat_spiral', 'Flat Spiral Coil'),
  smdCode('smd_code', 'SMD Code'),
  steelWeight('steel_weight', 'Steel Coil Weight'),
  steelUnwind('steel_unwind', 'Steel Coil Unwind');

  final String key;
  final String label;
  const CalculationType(this.key, this.label);

  static CalculationType? fromKey(String key) {
    for (final type in CalculationType.values) {
      if (type.key == key) return type;
    }
    return null;
  }
}

enum CalculationGroup {
  inductorColor('Inductor Color Bands', Icons.palette_outlined),
  coilCalculations('Coil Calculations', Icons.loop),
  smdCode('SMD Code', Icons.memory),
  steelCoil('Steel Coil', Icons.precision_manufacturing_outlined);

  final String label;
  final IconData icon;
  const CalculationGroup(this.label, this.icon);

  static CalculationGroup fromType(CalculationType type) {
    switch (type) {
      case CalculationType.inductorColor4:
      case CalculationType.inductorColor5:
        return CalculationGroup.inductorColor;
      case CalculationType.coilSingle:
      case CalculationType.coilMulti:
      case CalculationType.coilFlatSpiral:
        return CalculationGroup.coilCalculations;
      case CalculationType.smdCode:
        return CalculationGroup.smdCode;
      case CalculationType.steelWeight:
      case CalculationType.steelUnwind:
        return CalculationGroup.steelCoil;
    }
  }
}

class HistoryEntry {
  final int? id;
  final CalculationType type;
  final Map<String, dynamic> inputs;
  final Map<String, dynamic> result;
  final DateTime createdAt;

  HistoryEntry({
    this.id,
    required this.type,
    required this.inputs,
    required this.result,
    required this.createdAt,
  });

  String get resultSummary {
    final value = result['value'];
    final unit = result['unit'] ?? '';
    final tolerance = result['tolerance'];
    if (tolerance != null) {
      return '$value $unit ± ${tolerance}%';
    }
    return '$value $unit';
  }

  String get groupKey => CalculationGroup.fromType(type).name;
}

class HistoryViewModel extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  List<HistoryEntry> _entries = [];
  bool _isLoading = false;

  List<HistoryEntry> get entries => _entries;
  bool get isLoading => _isLoading;

  Map<CalculationGroup, List<HistoryEntry>> get groupedEntries {
    final map = <CalculationGroup, List<HistoryEntry>>{};
    for (final entry in _entries) {
      final group = CalculationGroup.fromType(entry.type);
      map.putIfAbsent(group, () => []).add(entry);
    }
    return map;
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    final calculations = await _db.getAllCalculations();
    _entries = calculations.map((calc) {
      final type = CalculationType.fromKey(calc.type);
      return HistoryEntry(
        id: calc.id,
        type: type ?? CalculationType.smdCode,
        inputs: calc.inputs,
        result: calc.result,
        createdAt: calc.createdAt,
      );
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCalculation(CalculationType type, Map<String, dynamic> inputs, Map<String, dynamic> result) async {
    final entry = CalculationEntry(
      type: type.key,
      inputs: inputs,
      result: result,
      createdAt: DateTime.now(),
    );
    await _db.insertCalculation(entry);
    await loadHistory();
  }

  Future<void> deleteEntry(int id) async {
    await _db.deleteCalculation(id);
    await loadHistory();
  }

  Future<void> clearAll() async {
    await _db.deleteAllCalculations();
    _entries = [];
    notifyListeners();
  }
}

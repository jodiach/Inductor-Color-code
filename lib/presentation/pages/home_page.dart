import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/inductor_calculator_vm.dart';
import '../viewmodels/coil_calculator_vm.dart';
import '../widgets/inductor_illustration.dart';
import '../widgets/value_display.dart';
import '../widgets/color_tile.dart';
import '../widgets/coil_geometry_diagram.dart';
import '../../core/constants/color_codes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inductor Calculator'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Inductor Calculator'),
            Tab(text: 'Coil Calculator'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInductorCalculatorTab(),
          _buildCoilCalculatorTab(),
        ],
      ),
    );
  }

  Widget _buildInductorCalculatorTab() {
    return Consumer<InductorCalculatorViewModel>(
      builder: (context, vm, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              InductorIllustration(bands: vm.bandColors),
              const SizedBox(height: 30),
              ValueDisplay(
                value: vm.inductance,
                tolerance: vm.tolerance,
              ),
              const SizedBox(height: 40),
              _buildBandCountToggle(vm),
              const SizedBox(height: 20),
              _buildBandSelectors(vm),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBandCountToggle(InductorCalculatorViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Band Count:', style: TextStyle(color: AppTheme.textSecondary)),
        const SizedBox(width: 16),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 4, label: Text('4-Band')),
            ButtonSegment(value: 5, label: Text('5-Band')),
          ],
          selected: {vm.bandCount},
          onSelectionChanged: (Set<int> selected) {
            vm.setBandCount(selected.first);
          },
        ),
      ],
    );
  }

  Widget _buildBandSelectors(InductorCalculatorViewModel vm) {
    if (vm.bandCount == 4) {
      return Column(
        children: [
          _buildBandRow('Digit 1', 0, vm, isDigit: true),
          _buildBandRow('Digit 2', 1, vm, isDigit: true),
          _buildBandRow('Multiplier', 2, vm, isMultiplier: true),
          _buildBandRow('Tolerance', 3, vm, isTolerance: true),
        ],
      );
    } else {
      return Column(
        children: [
          _buildBandRow('Digit 1', 0, vm, isDigit: true),
          _buildBandRow('Digit 2', 1, vm, isDigit: true),
          _buildBandRow('Digit 3', 2, vm, isDigit: true),
          _buildBandRow('Multiplier', 3, vm, isMultiplier: true),
          _buildBandRow('Tolerance', 4, vm, isTolerance: true),
        ],
      );
    }
  }

  Widget _buildBandRow(String label, int index, InductorCalculatorViewModel vm,
      {bool isDigit = false, bool isMultiplier = false, bool isTolerance = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildBandTiles(label, index, vm, isDigit: isDigit, isMultiplier: isMultiplier, isTolerance: isTolerance),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBandTiles(String label, int index, InductorCalculatorViewModel vm,
      {bool isDigit = false, bool isMultiplier = false, bool isTolerance = false}) {
    List<Widget> tiles = [];

    if (isDigit) {
      for (int i = 0; i < 10; i++) {
        tiles.add(ColorTile(
          color: InductorColorCodes.digitColors[i]!,
          isSelected: vm.digits[index] == i,
          onTap: () => vm.setDigit(index, i),
        ));
      }
    }

    if (isMultiplier) {
      for (int i = 0; i < 12; i++) {
        Color color;
        if (i < 10) {
          color = InductorColorCodes.multiplierColors[i]!;
        } else if (i == 10) {
          color = InductorColorCodes.multiplierColors[-1]!;
        } else {
          color = InductorColorCodes.multiplierColors[-2]!;
        }
        tiles.add(ColorTile(
          color: color,
          isSelected: false,
          onTap: () => vm.setMultiplier(i),
        ));
      }
    }

    if (isTolerance) {
      List<double> tolerances = [1.0, 2.0, 5.0, 10.0, 20.0];
      for (double tol in tolerances) {
        tiles.add(ColorTile(
          color: InductorColorCodes.toleranceColors[tol]!,
          isSelected: vm.tolerance == tol,
          onTap: () => vm.setTolerance(tol),
        ));
      }
    }

    return tiles;
  }

  Widget _buildCoilCalculatorTab() {
    return Consumer<CoilCalculatorViewModel>(
      builder: (context, vm, child) {
        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Single-Layer'),
                  Tab(text: 'Multi-Layer'),
                  Tab(text: 'Flat Spiral'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildSingleLayerTab(vm),
                    _buildMultiLayerTab(vm),
                    _buildFlatSpiralTab(vm),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSingleLayerTab(CoilCalculatorViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CoilGeometryDiagram(type: CoilGeometryType.singleLayer),
          const SizedBox(height: 30),
          ValueDisplay(value: vm.inductance),
          const SizedBox(height: 30),
          _buildTextField(
            label: 'Coil Diameter D (mm)',
            initialValue: vm.d.toString(),
            onChanged: (val) {
              double? d = double.tryParse(val);
              if (d != null) vm.updateSingleLayer(d, null, null);
            },
          ),
          _buildTextField(
            label: 'Coil Length L (mm)',
            initialValue: vm.l.toString(),
            onChanged: (val) {
              double? l = double.tryParse(val);
              if (l != null) vm.updateSingleLayer(null, l, null);
            },
          ),
          _buildTextField(
            label: 'Number of Turns N',
            initialValue: vm.n.toString(),
            onChanged: (val) {
              int? n = int.tryParse(val);
              if (n != null) vm.updateSingleLayer(null, null, n);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMultiLayerTab(CoilCalculatorViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CoilGeometryDiagram(type: CoilGeometryType.multiLayer),
          const SizedBox(height: 30),
          ValueDisplay(value: vm.inductance),
          const SizedBox(height: 30),
          _buildTextField(
            label: 'Inner Diameter d (mm)',
            initialValue: vm.dInner.toString(),
            onChanged: (val) {
              double? d = double.tryParse(val);
              if (d != null) vm.updateMultiLayer(d, null, null, null);
            },
          ),
          _buildTextField(
            label: 'Outer Diameter D (mm)',
            initialValue: vm.dOuter.toString(),
            onChanged: (val) {
              double? d = double.tryParse(val);
              if (d != null) vm.updateMultiLayer(null, d, null, null);
            },
          ),
          _buildTextField(
            label: 'Winding Length l (mm)',
            initialValue: vm.lMulti.toString(),
            onChanged: (val) {
              double? l = double.tryParse(val);
              if (l != null) vm.updateMultiLayer(null, null, l, null);
            },
          ),
          _buildTextField(
            label: 'Number of Turns N',
            initialValue: vm.nMulti.toString(),
            onChanged: (val) {
              int? n = int.tryParse(val);
              if (n != null) vm.updateMultiLayer(null, null, null, n);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFlatSpiralTab(CoilCalculatorViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CoilGeometryDiagram(type: CoilGeometryType.flatSpiral),
          const SizedBox(height: 30),
          ValueDisplay(value: vm.inductance),
          const SizedBox(height: 30),
          _buildTextField(
            label: 'Outer Diameter D (mm)',
            initialValue: vm.dOuterSpiral.toString(),
            onChanged: (val) {
              double? d = double.tryParse(val);
              if (d != null) vm.updateFlatSpiral(d, null, null, null);
            },
          ),
          _buildTextField(
            label: 'Trace Width w (mm)',
            initialValue: vm.w.toString(),
            onChanged: (val) {
              double? w = double.tryParse(val);
              if (w != null) vm.updateFlatSpiral(null, w, null, null);
            },
          ),
          _buildTextField(
            label: 'Trace Spacing s (mm)',
            initialValue: vm.s.toString(),
            onChanged: (val) {
              double? s = double.tryParse(val);
              if (s != null) vm.updateFlatSpiral(null, null, s, null);
            },
          ),
          _buildTextField(
            label: 'Number of Turns N',
            initialValue: vm.nSpiral.toString(),
            onChanged: (val) {
              int? n = int.tryParse(val);
              if (n != null) vm.updateFlatSpiral(null, null, null, n);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: TextEditingController(text: initialValue),
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppTheme.textSecondary),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.textSecondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.accentCyan),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
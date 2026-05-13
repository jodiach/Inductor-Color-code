import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter, HapticFeedback;
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/inductor_calculator_vm.dart';
import '../viewmodels/coil_calculator_vm.dart';
import '../viewmodels/history_vm.dart';
import '../widgets/inductor_illustration.dart';
import '../widgets/value_display.dart';
import '../widgets/color_tile.dart';
import '../widgets/coil_geometry_diagram.dart';
import '../../core/constants/color_codes.dart';
import 'history_page.dart';
import 'about_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final HistoryEntry? historyEntry;

  const HomePage({super.key, this.historyEntry});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Single Layer Controllers
  late TextEditingController _singleD;
  late TextEditingController _singleL;
  late TextEditingController _singleN;

  // Multi Layer Controllers
  late TextEditingController _multiDInner;
  late TextEditingController _multiDOuter;
  late TextEditingController _multiL;
  late TextEditingController _multiN;

  // Flat Spiral Controllers
  late TextEditingController _spiralD;
  late TextEditingController _spiralW;
  late TextEditingController _spiralS;
  late TextEditingController _spiralN;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _singleD = TextEditingController();
    _singleL = TextEditingController();
    _singleN = TextEditingController();
    _multiDInner = TextEditingController();
    _multiDOuter = TextEditingController();
    _multiL = TextEditingController();
    _multiN = TextEditingController();
    _spiralD = TextEditingController();
    _spiralW = TextEditingController();
    _spiralS = TextEditingController();
    _spiralN = TextEditingController();

    if (widget.historyEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadHistoryEntry(widget.historyEntry!);
      });
    }
  }

  void _loadHistoryEntry(HistoryEntry entry) {
    final type = entry.type;
    switch (type) {
      case CalculationType.inductorColor4:
      case CalculationType.inductorColor5:
        final vm = context.read<InductorCalculatorViewModel>();
        vm.loadFromHistory(entry.inputs);
        _tabController.animateTo(0);
        break;
      case CalculationType.coilSingle:
        final vm = context.read<CoilCalculatorViewModel>();
        vm.setActiveTypeAndLoad(type, entry.inputs);
        _tabController.animateTo(1);
        _populateCoilTextFields();
        break;
      case CalculationType.coilMulti:
        final vm = context.read<CoilCalculatorViewModel>();
        vm.setActiveTypeAndLoad(type, entry.inputs);
        _tabController.animateTo(1);
        _populateCoilTextFields();
        break;
      case CalculationType.coilFlatSpiral:
        final vm = context.read<CoilCalculatorViewModel>();
        vm.setActiveTypeAndLoad(type, entry.inputs);
        _tabController.animateTo(1);
        _populateCoilTextFields();
        break;
      case CalculationType.smdCode:
        _tabController.animateTo(3);
        break;
      case CalculationType.steelWeight:
      case CalculationType.steelUnwind:
        _tabController.animateTo(4);
        break;
    }
  }

  void _populateCoilTextFields() {
    final vm = context.read<CoilCalculatorViewModel>();
    switch (vm.activeType) {
      case CoilType.singleLayer:
        _singleD.text = vm.d > 0 ? vm.d.toString() : '';
        _singleL.text = vm.l > 0 ? vm.l.toString() : '';
        _singleN.text = vm.n > 0 ? vm.n.toString() : '';
        break;
      case CoilType.multiLayer:
        _multiDInner.text = vm.dInner > 0 ? vm.dInner.toString() : '';
        _multiDOuter.text = vm.dOuter > 0 ? vm.dOuter.toString() : '';
        _multiL.text = vm.lMulti > 0 ? vm.lMulti.toString() : '';
        _multiN.text = vm.nMulti > 0 ? vm.nMulti.toString() : '';
        break;
      case CoilType.flatSpiral:
        _spiralD.text = vm.dOuterSpiral > 0 ? vm.dOuterSpiral.toString() : '';
        _spiralW.text = vm.w > 0 ? vm.w.toString() : '';
        _spiralS.text = vm.s > 0 ? vm.s.toString() : '';
        _spiralN.text = vm.nSpiral > 0 ? vm.nSpiral.toString() : '';
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _singleD.dispose();
    _singleL.dispose();
    _singleN.dispose();
    _multiDInner.dispose();
    _multiDOuter.dispose();
    _multiL.dispose();
    _multiN.dispose();
    _spiralD.dispose();
    _spiralW.dispose();
    _spiralS.dispose();
    _spiralN.dispose();
    super.dispose();
  }

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.backgroundDeep : AppTheme.lightBackgroundDeep,
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildInductorCalculatorTab(),
                  _buildCoilCalculatorTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 0,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundSurface : AppTheme.lightBackgroundSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.accentNeon,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentNeon.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'INDUCTOR COIL CALCULATOR',
                style: AppTheme.labelStyle.copyWith(
                  fontSize: 12,
                  color: isDark ? AppTheme.accentNeon : AppTheme.lightTextPrimary,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
                  size: 20,
                ),
                onPressed: () => _showMenuSheet(context),
              ),
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  tabs: [
                    _buildTab('INDUCTOR', Icons.sell_outlined),
                    _buildTab('COIL', Icons.loop),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.history,
                  color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
                  size: 20,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryPage()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, IconData icon) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  void _showMenuSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.backgroundCard : AppTheme.lightBackgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              label: 'About',
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDark ? AppTheme.accentNeon : AppTheme.accentElectric),
      title: Text(
        label,
        style: TextStyle(
          color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
          fontFamily: 'SpaceGrotesk',
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
      ),
      onTap: onTap,
    );
  }

  Widget _buildInductorCalculatorTab() {
    return Consumer<InductorCalculatorViewModel>(
      builder: (context, vm, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              InductorIllustration(bands: vm.bandColors),
              const SizedBox(height: 20),
              ValueDisplay(value: vm.inductance, tolerance: vm.tolerance),
              const SizedBox(height: 24),
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BAND COUNT', style: AppTheme.labelStyle),
                    const SizedBox(height: 12),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 4, label: Text('4-BAND')),
                        ButtonSegment(value: 5, label: Text('5-BAND')),
                      ],
                      selected: {vm.bandCount},
                      onSelectionChanged: (Set<int> selected) {
                        HapticFeedback.selectionClick();
                        vm.setBandCount(selected.first);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildBandSelectors(vm),
              const SizedBox(height: 16),
              _buildSaveButton('Save to History', () => _saveInductorToHistory(vm)),
            ],
          ),
        );
      },
    );
  }

  void _saveInductorToHistory(InductorCalculatorViewModel vm) {
    final history = context.read<HistoryViewModel>();
    final type = vm.bandCount == 4 ? CalculationType.inductorColor4 : CalculationType.inductorColor5;
    history.addCalculation(type, {
      'bandCount': vm.bandCount,
      'digits': vm.digits,
      'multiplier': vm.multiplierValue,
      'tolerance': vm.tolerance,
    }, {
      'value': vm.inductance.toStringAsFixed(2),
      'unit': 'µH',
      'tolerance': vm.tolerance,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Saved to history',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            color: Colors.black,
          ),
        ),
        backgroundColor: AppTheme.accentNeon,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveCoilToHistory(CoilCalculatorViewModel vm, CalculationType type) {
    final history = context.read<HistoryViewModel>();
    Map<String, dynamic> inputs;
    Map<String, dynamic> result = {};

    switch (type) {
      case CalculationType.coilSingle:
        inputs = {'d': vm.d, 'l': vm.l, 'n': vm.n};
        result = {'value': vm.inductance?.toStringAsFixed(2) ?? '0', 'unit': 'µH'};
        break;
      case CalculationType.coilMulti:
        inputs = {'dInner': vm.dInner, 'dOuter': vm.dOuter, 'l': vm.lMulti, 'n': vm.nMulti};
        result = {'value': vm.inductance?.toStringAsFixed(2) ?? '0', 'unit': 'µH'};
        break;
      case CalculationType.coilFlatSpiral:
        inputs = {'dOuter': vm.dOuterSpiral, 'w': vm.w, 's': vm.s, 'n': vm.nSpiral};
        result = {'value': vm.inductance?.toStringAsFixed(2) ?? '0', 'unit': 'µH'};
        break;
      default:
        return;
    }

    history.addCalculation(type, inputs, result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Saved to history',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            color: Colors.black,
          ),
        ),
        backgroundColor: AppTheme.accentNeon,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildCoilCalculatorTab() {
    return Consumer<CoilCalculatorViewModel>(
      builder: (context, vm, child) {
        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.backgroundSurface : AppTheme.lightBackgroundSurface,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  isScrollable: true,
                  tabs: [
                    _buildSubTab('SINGLE LAYER'),
                    _buildSubTab('MULTI LAYER'),
                    _buildSubTab('FLAT SPIRAL'),
                  ],
                ),
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

  Widget _buildSubTab(String label) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSingleLayerTab(CoilCalculatorViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const CoilGeometryDiagram(type: CoilGeometryType.singleLayer),
          const SizedBox(height: 20),
          ValueDisplay(value: vm.inductance),
          const SizedBox(height: 20),
          _buildInputSection('PARAMETERS', [
            _buildTextField(label: 'Diameter D', controller: _singleD, onChanged: (val) {
              double? d = double.tryParse(val);
              if (d != null) vm.updateSingleLayer(d, null, null);
            }, hint: 'mm', errorText: vm.dError),
            _buildTextField(label: 'Length L', controller: _singleL, onChanged: (val) {
              double? l = double.tryParse(val);
              if (l != null) vm.updateSingleLayer(null, l, null);
            }, hint: 'mm', errorText: vm.lError),
            _buildTextField(label: 'Turns N', controller: _singleN, onChanged: (val) {
              int? n = int.tryParse(val);
              if (n != null) vm.updateSingleLayer(null, null, n);
            }, errorText: vm.nError, isDecimal: false),
          ]),
          const SizedBox(height: 16),
          _buildSaveButton('Save to History', () => _saveCoilToHistory(vm, CalculationType.coilSingle)),
        ],
      ),
    );
  }

  Widget _buildMultiLayerTab(CoilCalculatorViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const CoilGeometryDiagram(type: CoilGeometryType.multiLayer),
          const SizedBox(height: 20),
          ValueDisplay(value: vm.inductance),
          const SizedBox(height: 20),
          _buildInputSection('PARAMETERS', [
            _buildTextField(label: 'Inner Diameter d', controller: _multiDInner, onChanged: (val) {
              double? d = double.tryParse(val);
              if (d != null) vm.updateMultiLayer(d, null, null, null);
            }, hint: 'mm', errorText: vm.dInnerError),
            _buildTextField(label: 'Outer Diameter D', controller: _multiDOuter, onChanged: (val) {
              double? d = double.tryParse(val);
              if (d != null) vm.updateMultiLayer(null, d, null, null);
            }, hint: 'mm', errorText: vm.dOuterError),
            _buildTextField(label: 'Winding Length l', controller: _multiL, onChanged: (val) {
              double? l = double.tryParse(val);
              if (l != null) vm.updateMultiLayer(null, null, l, null);
            }, hint: 'mm', errorText: vm.lMultiError),
            _buildTextField(label: 'Turns N', controller: _multiN, onChanged: (val) {
              int? n = int.tryParse(val);
              if (n != null) vm.updateMultiLayer(null, null, null, n);
            }, errorText: vm.nMultiError, isDecimal: false),
          ]),
          const SizedBox(height: 16),
          _buildSaveButton('Save to History', () => _saveCoilToHistory(vm, CalculationType.coilMulti)),
        ],
      ),
    );
  }

  Widget _buildFlatSpiralTab(CoilCalculatorViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const CoilGeometryDiagram(type: CoilGeometryType.flatSpiral),
          const SizedBox(height: 20),
          ValueDisplay(value: vm.inductance),
          const SizedBox(height: 20),
          _buildInputSection('PARAMETERS', [
            _buildTextField(label: 'Outer Diameter D', controller: _spiralD, onChanged: (val) {
              double? d = double.tryParse(val);
              if (d != null) vm.updateFlatSpiral(d, null, null, null);
            }, hint: 'mm', errorText: vm.dSpiralError),
            _buildTextField(label: 'Trace Width w', controller: _spiralW, onChanged: (val) {
              double? w = double.tryParse(val);
              if (w != null) vm.updateFlatSpiral(null, w, null, null);
            }, hint: 'mm', errorText: vm.wError),
            _buildTextField(label: 'Trace Spacing s', controller: _spiralS, onChanged: (val) {
              double? s = double.tryParse(val);
              if (s != null) vm.updateFlatSpiral(null, null, s, null);
            }, hint: 'mm', errorText: vm.sError),
            _buildTextField(label: 'Turns N', controller: _spiralN, onChanged: (val) {
              int? n = int.tryParse(val);
              if (n != null) vm.updateFlatSpiral(null, null, null, n);
            }, errorText: vm.nSpiralError, isDecimal: false),
          ]),
          const SizedBox(height: 16),
          _buildSaveButton('Save to History', () => _saveCoilToHistory(vm, CalculationType.coilFlatSpiral)),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundCard : AppTheme.lightBackgroundCard,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildBandSelectors(InductorCalculatorViewModel vm) {
    if (vm.bandCount == 4) {
      return Column(
        children: [
          _buildBandRow('DIGIT 1', 0, vm, isDigit: true),
          _buildBandRow('DIGIT 2', 1, vm, isDigit: true),
          _buildBandRow('MULTIPLIER', 2, vm, isMultiplier: true),
          _buildBandRow('TOLERANCE', 3, vm, isTolerance: true),
        ],
      );
    } else {
      return Column(
        children: [
          _buildBandRow('DIGIT 1', 0, vm, isDigit: true),
          _buildBandRow('DIGIT 2', 1, vm, isDigit: true),
          _buildBandRow('DIGIT 3', 2, vm, isDigit: true),
          _buildBandRow('MULTIPLIER', 3, vm, isMultiplier: true),
          _buildBandRow('TOLERANCE', 4, vm, isTolerance: true),
        ],
      );
    }
  }

  Widget _buildBandRow(String label, int index, InductorCalculatorViewModel vm,
      {bool isDigit = false, bool isMultiplier = false, bool isTolerance = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundCard : AppTheme.lightBackgroundCard,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.labelStyle.copyWith(
            color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
          )),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildBandTiles(label, index, vm,
                  isDigit: isDigit, isMultiplier: isMultiplier, isTolerance: isTolerance),
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
          label: '$i',
          onTap: () {
            HapticFeedback.selectionClick();
            vm.setDigit(index, i);
          },
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
          isSelected: vm.isMultiplierSelected(i),
          onTap: () {
            HapticFeedback.selectionClick();
            vm.setMultiplier(i);
          },
        ));
      }
    }

    if (isTolerance) {
      List<double> tolerances = [1.0, 2.0, 5.0, 10.0, 20.0];
      for (double tol in tolerances) {
        tiles.add(ColorTile(
          color: InductorColorCodes.toleranceColors[tol]!,
          isSelected: vm.tolerance == tol,
          onTap: () {
            HapticFeedback.selectionClick();
            vm.setTolerance(tol);
          },
        ));
      }
    }

    return tiles;
  }

  Widget _buildInputSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundCard : AppTheme.lightBackgroundCard,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.labelStyle.copyWith(
            color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
          )),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    String? hint,
    String? errorText,
    bool isDecimal = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: isDecimal, signed: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(isDecimal ? RegExp(r'^-?\d*\.?\d*') : RegExp(r'^-?\d*')),
        ],
        style: TextStyle(
          color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
          fontFamily: 'JetBrainsMono',
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
          labelStyle: AppTheme.labelStyle.copyWith(
            color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
          ),
          hintStyle: TextStyle(
            color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
            fontSize: 11,
          ),
          errorStyle: TextStyle(
            color: AppTheme.error,
            fontFamily: 'JetBrainsMono',
            fontSize: 11,
          ),
          suffixIcon: Icon(Icons.edit, color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted, size: 16),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSaveButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.accentNeon.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppTheme.accentNeon, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_outlined, size: 18, color: AppTheme.accentNeon),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.accentNeon,
                fontFamily: 'SpaceGrotesk',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
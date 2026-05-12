import 'package:flutter/material.dart';
import 'package:inductor_coil_calculator/presentation/pages/about_page.dart';
import 'package:inductor_coil_calculator/presentation/pages/privacy_page.dart';
import 'package:inductor_coil_calculator/presentation/pages/terms_page.dart';
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
import 'inductor_color_bands_page.dart';
import 'smd_code_page.dart';
import 'steel_coil_page.dart';
import 'settings_page.dart';

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
                  isScrollable: true,
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
          _buildQuickActions(),
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

  Widget _buildQuickActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: [
          _buildActionChip(
            icon: Icons.palette_outlined,
            label: 'Color Bands',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InductorColorBandsPage()),
            ),
          ),
          const SizedBox(width: 8),
          _buildActionChip(
            icon: Icons.memory,
            label: 'SMD Code',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SmdCodePage()),
            ),
          ),
          const SizedBox(width: 8),
          _buildActionChip(
            icon: Icons.precision_manufacturing_outlined,
            label: 'Steel Coil',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SteelCoilPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: (isDark ? AppTheme.backgroundCard : AppTheme.lightBackgroundCard),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isDark ? AppTheme.accentNeon : AppTheme.accentElectric,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                fontSize: 11,
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Policy',
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.description_outlined,
              label: 'Terms of Service',
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TermsPage()),
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
            _buildTextField(label: 'Diameter D (mm)', value: vm.d.toString(), onChanged: (val) {
              double? d = double.tryParse(val);
              if (d != null) vm.updateSingleLayer(d, null, null);
            }),
            _buildTextField(label: 'Length L (mm)', value: vm.l.toString(), onChanged: (val) {
              double? l = double.tryParse(val);
              if (l != null) vm.updateSingleLayer(null, l, null);
            }),
            _buildTextField(label: 'Turns N', value: vm.n.toString(), onChanged: (val) {
              int? n = int.tryParse(val);
              if (n != null) vm.updateSingleLayer(null, null, n);
            }),
          ]),
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
            _buildTextField(label: 'Inner Diameter d (mm)', value: vm.dInner.toString(), onChanged: (val) {
              double? d = double.tryParse(val);
              if (d != null) vm.updateMultiLayer(d, null, null, null);
            }),
            _buildTextField(label: 'Outer Diameter D (mm)', value: vm.dOuter.toString(), onChanged: (val) {
              double? d = double.tryParse(val);
              if (d != null) vm.updateMultiLayer(null, d, null, null);
            }),
            _buildTextField(label: 'Winding Length l (mm)', value: vm.lMulti.toString(), onChanged: (val) {
              double? l = double.tryParse(val);
              if (l != null) vm.updateMultiLayer(null, null, l, null);
            }),
            _buildTextField(label: 'Turns N', value: vm.nMulti.toString(), onChanged: (val) {
              int? n = int.tryParse(val);
              if (n != null) vm.updateMultiLayer(null, null, null, n);
            }),
          ]),
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
            _buildTextField(label: 'Outer Diameter D (mm)', value: vm.dOuterSpiral.toString(), onChanged: (val) {
              double? d = double.tryParse(val);
              if (d != null) vm.updateFlatSpiral(d, null, null, null);
            }),
            _buildTextField(label: 'Trace Width w (mm)', value: vm.w.toString(), onChanged: (val) {
              double? w = double.tryParse(val);
              if (w != null) vm.updateFlatSpiral(null, w, null, null);
            }),
            _buildTextField(label: 'Trace Spacing s (mm)', value: vm.s.toString(), onChanged: (val) {
              double? s = double.tryParse(val);
              if (s != null) vm.updateFlatSpiral(null, null, s, null);
            }),
            _buildTextField(label: 'Turns N', value: vm.nSpiral.toString(), onChanged: (val) {
              int? n = int.tryParse(val);
              if (n != null) vm.updateFlatSpiral(null, null, null, n);
            }),
          ]),
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
          isSelected: vm.isMultiplierSelected(i),
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
    required String value,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: TextEditingController(text: value),
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
          fontFamily: 'SpaceGrotesk',
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTheme.labelStyle.copyWith(
            color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
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
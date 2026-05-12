import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/steel_coil_vm.dart';
import '../viewmodels/history_vm.dart';

class SteelCoilPage extends StatefulWidget {
  const SteelCoilPage({super.key});

  @override
  State<SteelCoilPage> createState() => _SteelCoilPageState();
}

class _SteelCoilPageState extends State<SteelCoilPage> {
  late SteelCoilViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = SteelCoilViewModel();
  }

  void _saveToHistory() {
    final history = context.read<HistoryViewModel>();
    final type = _vm.mode == SteelCoilMode.weight ? CalculationType.steelWeight : CalculationType.steelUnwind;
    history.addCalculation(type, _vm.toHistoryInputs(), _vm.toHistoryResult());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Saved to history',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.accentNeon.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDeep : AppTheme.lightBackgroundDeep,
      appBar: AppBar(
        title: Text(
          'STEEL COIL CALCULATOR',
          style: AppTheme.labelStyle.copyWith(
            color: isDark ? AppTheme.accentNeon : AppTheme.lightTextPrimary,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? AppTheme.backgroundDeep : AppTheme.lightBackgroundSurface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? AppTheme.accentNeon : AppTheme.lightTextPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_outlined, color: isDark ? AppTheme.accentNeon : AppTheme.accentElectric),
            onPressed: _saveToHistory,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildModeSelector(isDark),
                const SizedBox(height: 20),
                _buildInputSection(isDark),
                const SizedBox(height: 20),
                _buildResultSection(isDark),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildModeSelector(bool isDark) {
    return Container(
      width: double.infinity,
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'CALCULATION MODE',
              style: AppTheme.labelStyle.copyWith(
                color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
              ),
            ),
          ),
          SegmentedButton<SteelCoilMode>(
            segments: const [
              ButtonSegment(
                value: SteelCoilMode.weight,
                label: Text('WEIGHT'),
                icon: Icon(Icons.scale_outlined, size: 18),
              ),
              ButtonSegment(
                value: SteelCoilMode.unwind,
                label: Text('UNWIND'),
                icon: Icon(Icons.straighten_outlined, size: 18),
              ),
            ],
            selected: {_vm.mode},
            onSelectionChanged: (Set<SteelCoilMode> selected) {
              _vm.setMode(selected.first);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInputSection(bool isDark) {
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
          Text(
            'DIMENSIONS',
            style: AppTheme.labelStyle.copyWith(
              color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
            ),
          ),
          const SizedBox(height: 16),
          if (_vm.mode == SteelCoilMode.weight) ...[
            _buildTextField(
              label: 'Inner Diameter (in)',
              value: _vm.innerDiameter.toString(),
              onChanged: (v) => _vm.setInnerDiameter(double.tryParse(v) ?? 0),
              isDark: isDark,
            ),
            _buildTextField(
              label: 'Outer Diameter (in)',
              value: _vm.outerDiameter.toString(),
              onChanged: (v) => _vm.setOuterDiameter(double.tryParse(v) ?? 0),
              isDark: isDark,
            ),
            _buildTextField(
              label: 'Width (in)',
              value: _vm.width.toString(),
              onChanged: (v) => _vm.setWidth(double.tryParse(v) ?? 0),
              isDark: isDark,
            ),
            _buildTextField(
              label: 'Material Density (lb/in³)',
              value: _vm.density.toString(),
              onChanged: (v) => _vm.setDensity(double.tryParse(v) ?? 0),
              isDark: isDark,
              hint: 'Carbon steel: 0.284',
            ),
          ] else ...[
            _buildTextField(
              label: 'Inner Diameter (in)',
              value: _vm.innerDiameter.toString(),
              onChanged: (v) => _vm.setInnerDiameter(double.tryParse(v) ?? 0),
              isDark: isDark,
            ),
            _buildTextField(
              label: 'Outer Diameter (in)',
              value: _vm.outerDiameter.toString(),
              onChanged: (v) => _vm.setOuterDiameter(double.tryParse(v) ?? 0),
              isDark: isDark,
            ),
            _buildTextField(
              label: 'Material Thickness (in)',
              value: _vm.thickness.toString(),
              onChanged: (v) => _vm.setThickness(double.tryParse(v) ?? 0),
              isDark: isDark,
            ),
            _buildTextField(
              label: 'Strip Width (in)',
              value: _vm.stripWidth.toString(),
              onChanged: (v) => _vm.setStripWidth(double.tryParse(v) ?? 0),
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    required bool isDark,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: TextEditingController(text: value),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(
          color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
          fontFamily: 'JetBrainsMono',
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: AppTheme.labelStyle.copyWith(
            color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
          ),
          hintStyle: TextStyle(
            color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
            fontSize: 11,
          ),
          suffixIcon: Icon(Icons.edit, color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted, size: 16),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildResultSection(bool isDark) {
    if (_vm.mode == SteelCoilMode.weight) {
      return _buildWeightResults(isDark);
    } else {
      return _buildUnwindResults(isDark);
    }
  }

  Widget _buildWeightResults(bool isDark) {
    final result = _vm.weightResult;
    if (result == null) {
      return _buildEmptyResult('Enter coil dimensions to calculate weight', isDark);
    }

    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Icon(Icons.scale_outlined, size: 16, color: AppTheme.accentNeon),
              const SizedBox(width: 8),
              Text(
                'RESULTS',
                style: AppTheme.labelStyle.copyWith(
                  color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildResultRow('Total Weight', result.get('totalWeight'), isDark),
          const SizedBox(height: 12),
          _buildResultRow('Weight per Inch Width', result.get('weightPerInch'), isDark),
        ],
      ),
    );
  }

  Widget _buildUnwindResults(bool isDark) {
    final result = _vm.unwindResult;
    if (result == null) {
      return _buildEmptyResult('Enter coil dimensions to calculate', isDark);
    }

    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Icon(Icons.straighten_outlined, size: 16, color: AppTheme.accentNeon),
              const SizedBox(width: 8),
              Text(
                'RESULTS',
                style: AppTheme.labelStyle.copyWith(
                  color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildResultRow('Lineal Feet', result.get('linealFeet') + ' ft', isDark),
          const SizedBox(height: 12),
          _buildResultRow('Feet per Layer', result.get('feetPerLayer') + ' ft', isDark),
          const SizedBox(height: 12),
          _buildResultRow('Sheets per Coil', result.get('sheetsPerCoil'), isDark),
        ],
      ),
    );
  }

  Widget _buildEmptyResult(String message, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundCard : AppTheme.lightBackgroundCard,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
            fontFamily: 'SpaceGrotesk',
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
            fontFamily: 'SpaceGrotesk',
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppTheme.accentNeon,
            fontFamily: 'JetBrainsMono',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
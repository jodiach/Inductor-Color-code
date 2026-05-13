import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/smd_code_vm.dart';
import '../viewmodels/history_vm.dart';

class SmdCodePage extends StatefulWidget {
  const SmdCodePage({super.key});

  @override
  State<SmdCodePage> createState() => _SmdCodePageState();
}

class _SmdCodePageState extends State<SmdCodePage> {
  late SmdCodeViewModel _vm;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = SmdCodeViewModel();
    _controller.addListener(() {
      _vm.parseCode(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _vm.dispose();
    super.dispose();
  }

  void _saveToHistory() {
    if (_vm.result == null) return;
    final history = context.read<HistoryViewModel>();
    history.addCalculation(CalculationType.smdCode, {
      'code': _vm.result!.code,
      'type': _vm.result!.type.name,
    }, {
      'value': _vm.result!.valueUh.toStringAsFixed(2),
      'unit': _vm.result!.unit,
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDeep : AppTheme.lightBackgroundDeep,
      appBar: AppBar(
        title: Text(
          'SMD CODE CALCULATOR',
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
          ListenableBuilder(
            listenable: _vm,
            builder: (context, _) {
              if (_vm.result == null) return const SizedBox();
              return IconButton(
                icon: Icon(Icons.save_outlined, color: isDark ? AppTheme.accentNeon : AppTheme.accentElectric),
                onPressed: _saveToHistory,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildInfoCard(isDark),
            const SizedBox(height: 20),
            _buildInputCard(isDark),
            const SizedBox(height: 20),
            ListenableBuilder(
              listenable: _vm,
              builder: (context, _) {
                if (_vm.error != null) {
                  return _buildErrorCard(_vm.error!, isDark);
                }
                if (_vm.result != null) {
                  return _buildResultCard(_vm.result!, isDark);
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDark) {
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
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppTheme.accentElectric),
              const SizedBox(width: 8),
              Text(
                'SUPPORTED FORMATS',
                style: AppTheme.labelStyle.copyWith(
                  color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('EIA-96', '2 digits + letter (e.g., 01X, 25A, 96C)', isDark),
          const SizedBox(height: 8),
          _buildInfoRow('Numeric', '3 digits (e.g., 101, 220, 470)', isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String description, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.accentNeon,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: description,
                  style: TextStyle(
                    color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputCard(bool isDark) {
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
            'SMD CODE',
            style: AppTheme.labelStyle.copyWith(
              color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            style: TextStyle(
              color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
              fontFamily: 'JetBrainsMono',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
            decoration: InputDecoration(
              hintText: 'Enter code (e.g., 01X, 101)',
              hintStyle: TextStyle(
                color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
                fontFamily: 'JetBrainsMono',
                fontSize: 16,
                letterSpacing: 1,
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted),
                      onPressed: () {
                        _controller.clear();
                        _vm.clear();
                      },
                    )
                  : null,
            ),
            textCapitalization: TextCapitalization.characters,
            maxLength: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(SmdCodeResult result, bool isDark) {
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
              Icon(Icons.check_circle_outline, size: 20, color: AppTheme.accentNeon),
              const SizedBox(width: 8),
              Text(
                result.type == SmdCodeType.eia96 ? 'EIA-96 CODE' : 'NUMERIC CODE',
                style: AppTheme.labelStyle.copyWith(
                  color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              _formatValue(result.valueUh),
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentNeon,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isDark ? AppTheme.backgroundDeep : AppTheme.lightBackgroundDeep).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              result.breakdown,
              style: TextStyle(
                color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String error, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppTheme.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: AppTheme.error,
                fontFamily: 'SpaceGrotesk',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatValue(double value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(2)} mH';
    if (value >= 1) return '${value.toStringAsFixed(2)} µH';
    if (value >= 0.001) return '${(value * 1000).toStringAsFixed(2)} nH';
    return '${(value * 1000000).toStringAsFixed(2)} pH';
  }
}

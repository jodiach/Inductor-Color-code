import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDeep : AppTheme.lightBackgroundDeep,
      appBar: AppBar(
        title: Text(
          'ABOUT',
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 32),
          _buildSection('ABOUT THE APP', [
            'Inductor Coil Calculator is a professional-grade tool designed for engineers, technicians, and electronics hobbyists.',
            'Calculate inductor values from color codes (4-band, 5-band, and 6-band), decode SMD inductor codes, and compute air-core coil inductance for single-layer, multi-layer, and flat spiral configurations.',
          ], isDark),
          const SizedBox(height: 24),
          _buildSection('FEATURES', [
            '4-Band, 5-Band, and 6-Band Inductor Color Codes',
            'SMD Inductor Code Decoder (EIA-96 and Numeric)',
            'Single Layer Coil Inductance Calculator',
            'Multi Layer Coil Inductance Calculator',
            'Flat Spiral Coil Inductance Calculator',
            'Steel Coil Weight Calculator',
            'Steel Coil Unwind Calculator',
            'Dark and Light Theme Support',
            'Calculation History',
          ], isDark),
          const SizedBox(height: 24),
          _buildSection('VERSION', ['1.0.0'], isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.accentNeon.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.accentNeon.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.electric_bolt,
            size: 40,
            color: AppTheme.accentNeon,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Inductor Coil Calculator',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: 'SpaceGrotesk',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Professional Inductor & Coil Calculator',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
            fontSize: 13,
            fontFamily: 'SpaceGrotesk',
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.labelStyle.copyWith(
            color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
            children: items
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
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
                            child: Text(
                              item,
                              style: TextStyle(
                                color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                                fontSize: 14,
                                height: 1.5,
                                fontFamily: 'SpaceGrotesk',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

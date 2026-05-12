import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDeep : AppTheme.lightBackgroundDeep,
      appBar: AppBar(
        title: Text(
          'PRIVACY POLICY',
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
          Text(
            'Inductor Coil Calculator',
            style: TextStyle(
              color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Privacy Policy',
            style: TextStyle(
              color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
              fontSize: 13,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 24),
          _buildSection('DATA COLLECTION', [
            'Inductor Coil Calculator does not collect, store, or transmit any personal information.',
            'All calculation data is stored locally on your device only.',
            'We do not use any third-party analytics or tracking services.',
          ], isDark),
          const SizedBox(height: 20),
          _buildSection('LOCAL STORAGE', [
            'Calculation history is stored locally using SQLite on your device.',
            'Theme preference is stored locally using SharedPreferences.',
            'No data is transmitted to any external server.',
          ], isDark),
          const SizedBox(height: 20),
          _buildSection('PERMISSIONS', [
            'This app does not require any special permissions.',
            'No internet access is required for any app functionality.',
          ], isDark),
          const SizedBox(height: 20),
          _buildSection('UPDATES', [
            'This privacy policy may be updated from time to time.',
            'Continued use of the app after any changes constitutes acceptance of the updated policy.',
          ], isDark),
          const SizedBox(height: 20),
          _buildSection('CONTACT', [
            'If you have any questions about this privacy policy, please contact us through the app store listing.',
          ], isDark),
        ],
      ),
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

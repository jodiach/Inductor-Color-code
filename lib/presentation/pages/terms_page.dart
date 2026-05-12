import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDeep : AppTheme.lightBackgroundDeep,
      appBar: AppBar(
        title: Text(
          'TERMS OF SERVICE',
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
            'Terms of Service',
            style: TextStyle(
              color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
              fontSize: 13,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 24),
          _buildSection('ACCEPTANCE', [
            'By downloading and using Inductor Coil Calculator, you agree to these terms of service.',
            'If you do not agree to these terms, please do not use the application.',
          ], isDark),
          const SizedBox(height: 20),
          _buildSection('USE OF SERVICE', [
            'Inductor Coil Calculator provides calculation tools for inductor values, coil inductance, and steel coil parameters.',
            'The app is intended for educational, professional, and personal use.',
            'You agree to use the app only for lawful purposes.',
          ], isDark),
          const SizedBox(height: 20),
          _buildSection('ACCURACY', [
            'All calculations provided by this app are for reference purposes only.',
            'While we strive for accuracy, we cannot guarantee the accuracy of all results.',
            'Users should verify critical calculations with additional sources.',
            'The developers are not liable for any damages arising from reliance on the app\'s calculations.',
          ], isDark),
          const SizedBox(height: 20),
          _buildSection('INTELLECTUAL PROPERTY', [
            'All content, design, and code in this application are the property of the developer.',
            'You may not reproduce, modify, or distribute any part of this application without permission.',
          ], isDark),
          const SizedBox(height: 20),
          _buildSection('CHANGES TO TERMS', [
            'These terms may be updated from time to time.',
            'Continued use of the app after changes constitutes acceptance of the updated terms.',
          ], isDark),
          const SizedBox(height: 20),
          _buildSection('CONTACT', [
            'For questions about these terms, please contact us through the app store listing.',
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
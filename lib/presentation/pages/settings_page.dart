import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/theme_vm.dart';
import 'about_page.dart';
import 'privacy_page.dart';
import 'terms_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDeep : AppTheme.lightBackgroundDeep,
      appBar: AppBar(
        title: Text(
          'SETTINGS',
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
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('APPEARANCE', isDark),
          const SizedBox(height: 8),
          _buildCard([
            Consumer<ThemeViewModel>(
              builder: (context, themeVm, _) {
                return _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: themeVm.isDarkMode ? 'Enabled' : 'Disabled',
                  value: themeVm.isDarkMode,
                  onChanged: (_) => themeVm.toggleTheme(),
                  isDark: isDark,
                );
              },
            ),
          ], isDark),
          const SizedBox(height: 24),
          _buildSectionTitle('INFORMATION', isDark),
          const SizedBox(height: 8),
          _buildCard([
            _buildNavTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App info and features',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage())),
              isDark: isDark,
            ),
            _buildDivider(isDark),
            _buildNavTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'How we handle your data',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPage())),
              isDark: isDark,
            ),
            _buildDivider(isDark),
            _buildNavTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Usage terms and conditions',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsPage())),
              isDark: isDark,
            ),
          ], isDark),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Inductor Coil Calculator v1.0.0',
              style: AppTheme.labelStyle.copyWith(
                color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: AppTheme.labelStyle.copyWith(
        color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
      ),
    );
  }

  Widget _buildCard(List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundCard : AppTheme.lightBackgroundCard,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
          width: 1,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      indent: 56,
      color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDark ? AppTheme.accentNeon : AppTheme.accentElectric),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
          fontFamily: 'SpaceGrotesk',
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
          fontFamily: 'SpaceGrotesk',
          fontSize: 12,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppTheme.accentNeon.withValues(alpha: 0.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDark ? AppTheme.accentNeon : AppTheme.accentElectric),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
          fontFamily: 'SpaceGrotesk',
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
          fontFamily: 'SpaceGrotesk',
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
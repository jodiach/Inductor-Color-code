import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/color_codes.dart';

class InductorColorBandsPage extends StatefulWidget {
  const InductorColorBandsPage({super.key});

  @override
  State<InductorColorBandsPage> createState() => _InductorColorBandsPageState();
}

class _InductorColorBandsPageState extends State<InductorColorBandsPage> {
  static const int _itemsPerPage = 10;
  int _currentPage = 0;

  void _nextPage(int totalItems) {
    final maxPage = (totalItems / _itemsPerPage).ceil() - 1;
    setState(() {
      _currentPage = _currentPage < maxPage ? _currentPage + 1 : 0;
    });
  }

  void _prevPage() {
    setState(() {
      _currentPage = _currentPage > 0 ? _currentPage - 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDeep : AppTheme.lightBackgroundDeep,
      appBar: AppBar(
        title: Text(
          'INDUCTOR COLOR BANDS',
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
        actions: const [],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPaginatedSection(
            'DIGIT COLORS',
            InductorColorCodes.digitColors.entries.map((e) {
              return _buildColorItem('${e.key}', 'DIGIT', e.value);
            }).toList(),
            isDark,
            InductorColorCodes.digitColors.length,
          ),
          const SizedBox(height: 16),
          _buildPaginatedSection(
            'MULTIPLIER COLORS',
            InductorColorCodes.multiplierColors.entries.map((e) {
              String label;
              if (e.key == -1) label = 'GOLD';
              else if (e.key == -2) label = 'SILVER';
              else label = 'x${e.key}';
              return _buildColorItem(label, '', e.value);
            }).toList(),
            isDark,
            InductorColorCodes.multiplierColors.length,
          ),
          const SizedBox(height: 16),
          _buildPaginatedSection(
            'TOLERANCE COLORS',
            InductorColorCodes.toleranceColors.entries.map((e) {
              return _buildColorItem('${e.key}%', '', e.value);
            }).toList(),
            isDark,
            InductorColorCodes.toleranceColors.length,
          ),
        ],
      ),
    );
  }

  Widget _buildPaginatedSection(String title, List<Widget> items, bool isDark, int totalItems) {
    final totalPages = (totalItems / _itemsPerPage).ceil();
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage > totalItems) ? totalItems : startIndex + _itemsPerPage;
    final pageItems = items.sublist(startIndex, endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTheme.labelStyle.copyWith(
              color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
            )),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 20, color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted),
                  onPressed: _currentPage > 0 ? _prevPage : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                Text(
                  '${_currentPage + 1}/$totalPages',
                  style: TextStyle(
                    color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
                    fontSize: 12,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, size: 20, color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted),
                  onPressed: _currentPage < totalPages - 1 ? () => _nextPage(totalItems) : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.backgroundCard : AppTheme.lightBackgroundCard,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
              width: 1,
            ),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pageItems,
          ),
        ),
      ],
    );
  }

  Widget _buildColorItem(String label, String value, Color color) {
    return Container(
      width: 70,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.black26, width: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, fontFamily: 'SpaceGrotesk'),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9, color: Colors.grey[600], fontFamily: 'JetBrainsMono'),
            ),
        ],
      ),
    );
  }
}
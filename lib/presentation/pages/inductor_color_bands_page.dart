import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/color_codes.dart';
import '../widgets/inductor_illustration.dart';

class InductorColorBandsPage extends StatefulWidget {
  const InductorColorBandsPage({super.key});

  @override
  State<InductorColorBandsPage> createState() => _InductorColorBandsPageState();
}

class _InductorColorBandsPageState extends State<InductorColorBandsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _bandCount = 4;
  int _digit1 = 0;
  int _digit2 = 0;
  int _digit3 = 0;
  double _multiplier = 1.0;
  double _tolerance = 5.0;

  // Pagination
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
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get _inductance {
    final digits = _bandCount == 4 ? '$_digit1$_digit2' : '$_digit1$_digit2$_digit3';
    final base = double.parse(digits);
    return base * _multiplier;
  }

  List<Color> get _bandColors {
    final colors = <Color>[];
    colors.add(InductorColorCodes.digitColors[_digit1]!);
    colors.add(InductorColorCodes.digitColors[_digit2]!);
    if (_bandCount == 5) colors.add(InductorColorCodes.digitColors[_digit3]!);
    colors.add(_getMultiplierColor(_multiplier));
    colors.add(InductorColorCodes.toleranceColors[_tolerance]!);
    return colors;
  }

  Color _getMultiplierColor(double mult) {
    final colorMap = InductorColorCodes.multiplierColors;
    if (mult == 0.001) return colorMap[-3] ?? Colors.black;
    if (mult == 0.01) return colorMap[-2] ?? Colors.black;
    if (mult == 0.1) return colorMap[-1] ?? Colors.black;
    final intKey = mult.toInt();
    return colorMap[intKey] ?? Colors.black;
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'REFERENCE'),
            Tab(text: 'CALCULATOR'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReferenceTab(isDark),
          _buildCalculatorTab(isDark),
        ],
      ),
    );
  }

  Widget _buildReferenceTab(bool isDark) {
    return ListView(
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

  Widget _buildCalculatorTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          InductorIllustration(bands: _bandColors),
          const SizedBox(height: 20),
          _buildResultCard(isDark),
          const SizedBox(height: 20),
          _buildBandCountSelector(isDark),
          const SizedBox(height: 16),
          _buildBandSelectors(isDark),
        ],
      ),
    );
  }

  Widget _buildResultCard(bool isDark) {
    return Container(
      width: double.infinity,
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
        children: [
          Text('INDUCTANCE', style: AppTheme.labelStyle.copyWith(
            color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
          )),
          const SizedBox(height: 8),
          Text(
            _formatValue(_inductance),
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppTheme.accentNeon,
              letterSpacing: 2,
            ),
          ),
          if (_tolerance > 0) ...[
            const SizedBox(height: 8),
            Text(
              '± ${_tolerance}%',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 14,
                color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatValue(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(2)} mH';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(2)} mH';
    if (value >= 1) return '${value.toStringAsFixed(2)} µH';
    if (value >= 0.001) return '${(value * 1000).toStringAsFixed(2)} nH';
    return '${(value * 1000000).toStringAsFixed(2)} pH';
  }

  Widget _buildBandCountSelector(bool isDark) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BAND COUNT', style: AppTheme.labelStyle.copyWith(
            color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
          )),
          const SizedBox(height: 12),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 4, label: Text('4-BAND')),
              ButtonSegment(value: 5, label: Text('5-BAND')),
            ],
            selected: {_bandCount},
            onSelectionChanged: (Set<int> selected) {
              HapticFeedback.selectionClick();
              setState(() => _bandCount = selected.first);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBandSelectors(bool isDark) {
    if (_bandCount == 4) {
      return Column(children: [
        _buildDigitSelector('DIGIT 1', _digit1, (v) => setState(() => _digit1 = v), isDark),
        _buildDigitSelector('DIGIT 2', _digit2, (v) => setState(() => _digit2 = v), isDark),
        _buildMultiplierSelector('MULTIPLIER', isDark),
        _buildToleranceSelector('TOLERANCE', isDark),
      ]);
    } else {
      return Column(children: [
        _buildDigitSelector('DIGIT 1', _digit1, (v) => setState(() => _digit1 = v), isDark),
        _buildDigitSelector('DIGIT 2', _digit2, (v) => setState(() => _digit2 = v), isDark),
        _buildDigitSelector('DIGIT 3', _digit3, (v) => setState(() => _digit3 = v), isDark),
        _buildMultiplierSelector('MULTIPLIER', isDark),
        _buildToleranceSelector('TOLERANCE', isDark),
      ]);
    }
  }

  Widget _buildDigitSelector(String label, int value, ValueChanged<int> onChanged, bool isDark) {
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
              children: List.generate(10, (i) => _buildDigitTile(i, i == value, () => onChanged(i), isDark)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDigitTile(int digit, bool selected, VoidCallback onTap, bool isDark) {
    final color = InductorColorCodes.digitColors[digit]!;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: selected ? AppTheme.accentNeon : Colors.black26,
            width: selected ? 2 : 0.5,
          ),
          boxShadow: selected ? [
            BoxShadow(color: AppTheme.accentNeon.withValues(alpha: 0.4), blurRadius: 8),
          ] : null,
        ),
        child: Center(
          child: Text(
            digit.toString(),
            style: TextStyle(
              color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiplierSelector(String label, bool isDark) {
    final multValues = <double>[0.001, 0.01, 0.1, 1.0, 10.0, 100.0, 1000.0, 10000.0, 100000.0, 1000000.0];
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
              children: multValues.map((mult) {
                final color = _getMultiplierColor(mult);
                final selected = _multiplier == mult;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _multiplier = mult);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: selected ? AppTheme.accentNeon : Colors.black26,
                        width: selected ? 2 : 0.5,
                      ),
                      boxShadow: selected ? [
                        BoxShadow(color: AppTheme.accentNeon.withValues(alpha: 0.4), blurRadius: 8),
                      ] : null,
                    ),
                    child: Text(
                      _formatMultiplier(mult),
                      style: TextStyle(
                        color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatMultiplier(double mult) {
    if (mult == 0.001) return 'm';
    if (mult == 0.01) return 'c';
    if (mult == 0.1) return 'd';
    return mult.toInt().toString();
  }

  Widget _buildToleranceSelector(String label, bool isDark) {
    final tolerances = [1.0, 2.0, 5.0, 10.0, 20.0];
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
              children: tolerances.map((tol) {
                final color = InductorColorCodes.toleranceColors[tol]!;
                final selected = _tolerance == tol;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _tolerance = tol);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: selected ? AppTheme.accentNeon : Colors.black26,
                        width: selected ? 2 : 0.5,
                      ),
                      boxShadow: selected ? [
                        BoxShadow(color: AppTheme.accentNeon.withValues(alpha: 0.4), blurRadius: 8),
                      ] : null,
                    ),
                    child: Text(
                      '$tol%',
                      style: TextStyle(
                        color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
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
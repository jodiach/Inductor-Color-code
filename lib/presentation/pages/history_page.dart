import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/history_vm.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryViewModel>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDeep : AppTheme.lightBackgroundDeep,
      appBar: AppBar(
        title: Text(
          'HISTORY',
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
          Consumer<HistoryViewModel>(
            builder: (context, vm, _) {
              if (vm.entries.isEmpty) return const SizedBox();
              return IconButton(
                icon: Icon(Icons.delete_sweep, color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted),
                onPressed: () => _showClearDialog(context, vm),
              );
            },
          ),
        ],
      ),
      body: Consumer<HistoryViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.accentNeon),
            );
          }

          if (vm.entries.isEmpty) {
            return _buildEmptyState(isDark);
          }

          final grouped = vm.groupedEntries;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final group = grouped.keys.elementAt(index);
              final entries = grouped[group]!;
              return _buildGroupSection(group, entries, isDark, vm);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No History Yet',
            style: TextStyle(
              color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your saved calculations will appear here',
            style: TextStyle(
              color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
              fontSize: 14,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupSection(CalculationGroup group, List<HistoryEntry> entries, bool isDark, HistoryViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(group.icon, size: 16, color: isDark ? AppTheme.accentNeon : AppTheme.accentElectric),
            const SizedBox(width: 8),
            Text(
              group.label.toUpperCase(),
              style: AppTheme.labelStyle.copyWith(
                color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...entries.map((entry) => _buildEntryTile(entry, isDark, vm)),
      ],
    );
  }

  Widget _buildEntryTile(HistoryEntry entry, bool isDark, HistoryViewModel vm) {
    return Dismissible(
      key: Key('history_${entry.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppTheme.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(Icons.delete_outline, color: AppTheme.error),
      ),
      onDismissed: (_) {
        if (entry.id != null) {
          vm.deleteEntry(entry.id!);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.backgroundCard : AppTheme.lightBackgroundCard,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isDark ? AppTheme.borderSubtle : AppTheme.lightBorderSubtle,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.type.label,
                    style: TextStyle(
                      color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                      fontSize: 11,
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.resultSummary,
                    style: TextStyle(
                      color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                      fontSize: 16,
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(entry.createdAt),
                    style: TextStyle(
                      color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
                      fontSize: 11,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? AppTheme.textMuted : AppTheme.lightTextMuted,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showClearDialog(BuildContext context, HistoryViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.backgroundCard
            : AppTheme.lightBackgroundCard,
        title: Text(
          'Clear History',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.textPrimary
                : AppTheme.lightTextPrimary,
            fontFamily: 'SpaceGrotesk',
          ),
        ),
        content: Text(
          'Are you sure you want to delete all history?',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.textSecondary
                : AppTheme.lightTextSecondary,
            fontFamily: 'SpaceGrotesk',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              vm.clearAll();
              Navigator.pop(ctx);
            },
            child: Text('Clear All', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}
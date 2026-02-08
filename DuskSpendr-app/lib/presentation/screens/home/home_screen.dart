import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/budget_provider.dart';
import '../../../providers/gamification_provider.dart';
import '../../../providers/transaction_provider.dart';
import '../../../providers/sync_providers.dart';
import '../../../core/sync/sync_metrics_service.dart';
import '../../navigation/navigation.dart';
import '../settings/settings_screen.dart';

/// SS-081: Student Dashboard wired with real providers

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: _buildSpeedDialFab(),
      body: const _HomeDashboard(),
    );
  }

  /// SS-086: Speed Dial FAB for quick actions
  Widget _buildSpeedDialFab() {
    return FloatingActionButton(
      onPressed: () {
        _showAddOptions(context);
      },
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Add Transaction', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _QuickAddOption(
                  icon: Icons.arrow_upward,
                  label: 'Expense',
                  color: AppColors.danger,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.addTransaction);
                  },
                ),
                _QuickAddOption(
                  icon: Icons.arrow_downward,
                  label: 'Income',
                  color: AppColors.accent,
                  onTap: () {
                    Navigator.pop(context);
                    // Reuse existing add-transaction flow (credit/income)
                    // You might want to pass a query param or extra to pre-select income
                    context.push(AppRoutes.addTransaction);
                  },
                ),
                _QuickAddOption(
                  icon: Icons.swap_horiz,
                  label: 'Transfer',
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.pop(context);
                    // Transfer UI not yet implemented; route to transactions for now
                    context.push(AppRoutes.addTransaction);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _QuickAddOption extends StatelessWidget {
  const _QuickAddOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

class _HomeDashboard extends ConsumerWidget {
  const _HomeDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? AppColors.gradientNight
            : AppColors.gradientPrimary,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.screenVertical,
          ),
          child: ListView(
            children: const [
              _Header(),
              SizedBox(height: AppSpacing.lg),
              _BalanceCard(),
              SizedBox(height: AppSpacing.lg),
              _SpendingCard(),
              SizedBox(height: AppSpacing.lg),
              _SyncHealthCard(),
              SizedBox(height: AppSpacing.lg),
              _TransactionsCard(),
              SizedBox(height: AppSpacing.lg),
              _QuickActions(),
              SizedBox(height: AppSpacing.lg),
              _ScoreCard(),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncHealthCard extends ConsumerWidget {
  const _SyncHealthCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final health = ref.watch(syncHealthProvider);
    final outboxStats = ref.watch(syncOutboxStatsProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sync, color: theme.colorScheme.onSurface),
              const SizedBox(width: AppSpacing.sm),
              const Text('Sync Health', style: AppTypography.h3),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          health.when(
            data: (summary) {
              final statusColor = _statusColor(summary.status);
              final lastSync = summary.lastSuccessfulSync != null
                  ? DateFormat('dd MMM, HH:mm').format(summary.lastSuccessfulSync!)
                  : 'Never';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _statusLabel(summary.status),
                          style: AppTypography.caption.copyWith(color: statusColor),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Success ${summary.successRate.toStringAsFixed(0)}%',
                        style: AppTypography.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Last sync: $lastSync',
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              );
            },
            loading: () => const LinearProgressIndicator(minHeight: 4),
            error: (err, _) => Text(
              'Sync health unavailable',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.danger,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          outboxStats.when(
            data: (stats) => Row(
              children: [
                _OutboxChip(
                  label: 'Pending',
                  value: stats.pending,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.sm),
                _OutboxChip(
                  label: 'Failed',
                  value: stats.failed,
                  color: AppColors.danger,
                ),
                const SizedBox(width: AppSpacing.sm),
                _OutboxChip(
                  label: 'Synced',
                  value: stats.succeeded,
                  color: AppColors.accent,
                ),
              ],
            ),
            loading: () => const SizedBox(
              height: 24,
              child: LinearProgressIndicator(minHeight: 4),
            ),
            error: (err, _) => Text(
              'Outbox stats unavailable',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(SyncHealthStatus status) {
    switch (status) {
      case SyncHealthStatus.healthy:
        return AppColors.success;
      case SyncHealthStatus.degraded:
        return AppColors.warning;
      case SyncHealthStatus.unhealthy:
      case SyncHealthStatus.critical:
        return AppColors.danger;
    }
  }

  String _statusLabel(SyncHealthStatus status) {
    switch (status) {
      case SyncHealthStatus.healthy:
        return 'Healthy';
      case SyncHealthStatus.degraded:
        return 'Degraded';
      case SyncHealthStatus.unhealthy:
        return 'Unhealthy';
      case SyncHealthStatus.critical:
        return 'Critical';
    }
  }
}

class _OutboxChip extends StatelessWidget {
  const _OutboxChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label $value',
        style: AppTypography.caption.copyWith(color: color),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = _getGreeting();
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$greeting 👋',
                  style: AppTypography.h2.copyWith(
                    color: theme.colorScheme.onSurface,
                  )),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Your money is calm tonight',
                style: AppTypography.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications, color: theme.colorScheme.onSurface),
        ),
        IconButton(
          onPressed: () {
            context.push(AppRoutes.settings);
          },
          icon: Icon(Icons.settings, color: theme.colorScheme.onSurface),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _BalanceCard extends ConsumerWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totalBalance = ref.watch(totalBalanceProvider);
    final linkedAccounts = ref.watch(linkedAccountsProvider);
    final formatter =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Balance',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              )),
          const SizedBox(height: AppSpacing.sm),
          totalBalance.when(
            data: (balance) => Text(
              formatter.format(balance.inRupees),
              style: AppTypography.displayLarge.copyWith(
                fontSize: 36,
                color: theme.colorScheme.onSurface,
              ),
            ),
            loading: () => const SizedBox(
              height: 36,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) => Text(
              '₹--',
              style: AppTypography.displayLarge.copyWith(
                fontSize: 36,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.accent, size: 18),
              const SizedBox(width: 6),
              Text('View spending trends',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.accent,
                  )),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 36,
            child: linkedAccounts.when(
              data: (accounts) => ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: accounts.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return _AccountChip(
                    label:
                        '${account.displayName} ${formatter.format(account.balance?.inRupees ?? 0)}',
                  );
                },
              ),
              loading: () => const CircularProgressIndicator(strokeWidth: 2),
              error: (_, __) => const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountChip extends StatelessWidget {
  const _AccountChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: AppTypography.bodyMedium.copyWith(
            color: theme.colorScheme.onSurface,
          )),
    );
  }
}

class _SpendingCard extends ConsumerWidget {
  const _SpendingCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final budgetProgress = ref.watch(budgetProgressProvider);
    final categorySpending = ref.watch(categorySpendingProvider);
    final formatter =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("This Month's Spending",
              style: AppTypography.h3.copyWith(
                color: theme.colorScheme.onSurface,
              )),
          const SizedBox(height: AppSpacing.sm),
          budgetProgress.when(
            data: (progress) {
              if (progress.isEmpty) {
                return Text('No budget set',
                    style: AppTypography.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ));
              }
              final overall = progress.firstWhere(
                (p) => p.budget.category == null,
                orElse: () => progress.first,
              );
              final spent = overall.budget.spent.inRupees;
              final limit = overall.budget.limit.inRupees;
              final percentage = limit > 0 ? spent / limit : 0.0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${formatter.format(spent)} spent of ${formatter.format(limit)}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: percentage.clamp(0.0, 1.0),
                      minHeight: 8,
                      color: percentage > 0.9
                          ? AppColors.danger
                          : AppColors.warning,
                      backgroundColor:
                          theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) => const Text('Error loading budget'),
          ),
          const SizedBox(height: AppSpacing.md),
          categorySpending.when(
            data: (categories) {
              final sorted = categories.entries.toList()
                ..sort((a, b) => b.value.paisa.compareTo(a.value.paisa));
              final top3 = sorted.take(3).toList();
              return Column(
                children: top3.map((entry) {
                  final maxSpent =
                      sorted.isNotEmpty ? sorted.first.value.paisa : 1;
                  final ratio = entry.value.paisa / maxSpent;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _MiniCategoryBar(
                      icon: _getCategoryEmoji(entry.key),
                      label: entry.key.name.toUpperCase(),
                      amount: formatter.format(entry.value.inRupees),
                      value: ratio,
                      color: AppColors.getCategoryColor(entry.key.name),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox(height: 60),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  String _getCategoryEmoji(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food:
        return '🍔';
      case TransactionCategory.transportation:
        return '🚗';
      case TransactionCategory.entertainment:
        return '🎮';
      case TransactionCategory.shopping:
        return '🛍️';
      case TransactionCategory.utilities:
        return '📱';
      case TransactionCategory.healthcare:
        return '💊';
      case TransactionCategory.education:
        return '📚';
      case TransactionCategory.subscriptions:
        return '🔁';
      case TransactionCategory.investments:
        return '📈';
      case TransactionCategory.loans:
        return '💳';
      case TransactionCategory.shared:
        return '👥';
      case TransactionCategory.pocketMoney:
        return '💵';
      case TransactionCategory.other:
        return '💳';
    }
  }
}

class _MiniCategoryBar extends StatelessWidget {
  const _MiniCategoryBar({
    required this.icon,
    required this.label,
    required this.amount,
    required this.value,
    required this.color,
  });

  final String icon;
  final String label;
  final String amount;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(icon),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(label,
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface,
              )),
        ),
        Text(amount,
            style: AppTypography.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            )),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              color: color,
              backgroundColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
        ),
      ],
    );
  }
}

class _TransactionsCard extends ConsumerWidget {
  const _TransactionsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recentTx = ref.watch(recentTransactionsProvider);
    final formatter =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final dateFormat = DateFormat('MMM d, h:mm a');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Transactions',
              style: AppTypography.h3.copyWith(
                color: theme.colorScheme.onSurface,
              )),
          const SizedBox(height: AppSpacing.md),
          recentTx.when(
            data: (transactions) {
              if (transactions.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(
                    child: Text(
                      'No transactions yet',
                      style: AppTypography.bodyMedium.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: transactions.take(3).map((tx) {
                  final isIncome = tx.type == TransactionType.credit;
                  final amount = isIncome
                      ? '+${formatter.format(tx.amount.inRupees)}'
                      : '-${formatter.format(tx.amount.inRupees)}';
                  return Column(
                    children: [
                      _TransactionRow(
                        icon: _getCategoryEmoji(tx.category),
                        title: tx.description ?? tx.category.name,
                        subtitle:
                            '${tx.category.name} • ${dateFormat.format(tx.timestamp)}',
                        amount: amount,
                        isIncome: isIncome,
                      ),
                      if (transactions.indexOf(tx) < 2)
                        Divider(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.1)),
                    ],
                  );
                }).toList(),
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) => const Text('Error loading transactions'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                context.goNamed('transactions');
              },
              child: const Text('See All Transactions →'),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryEmoji(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food:
        return '🍕';
      case TransactionCategory.transportation:
        return '🚕';
      case TransactionCategory.entertainment:
        return '🎮';
      case TransactionCategory.shopping:
        return '🛍️';
      case TransactionCategory.utilities:
        return '📱';
      case TransactionCategory.healthcare:
        return '💊';
      case TransactionCategory.education:
        return '📚';
      case TransactionCategory.investments:
        return '📈';
      case TransactionCategory.subscriptions:
        return '🔁';
      case TransactionCategory.shared:
        return '👥';
      case TransactionCategory.pocketMoney:
        return '💵';
      default:
        return '💳';
    }
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
  });

  final String icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.bodyLarge.copyWith(
                      color: theme.colorScheme.onSurface,
                    )),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    )),
              ],
            ),
          ),
          Text(amount,
              style: AppTypography.bodyLarge.copyWith(
                color:
                    isIncome ? AppColors.accent : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions',
            style: AppTypography.h3.copyWith(
              color: theme.colorScheme.onSurface,
            )),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _QuickActionItem(
              icon: Icons.add,
              label: 'Add',
              onTap: () {
                 context.push(AppRoutes.addTransaction);
              },
            ),
            _QuickActionItem(
              icon: Icons.pie_chart,
              label: 'Stats',
              onTap: () {
                 context.go(AppRoutes.stats);
              },
            ),
            _QuickActionItem(
              icon: Icons.group,
              label: 'Split',
              onTap: () {
                 context.push(AppRoutes.splitBills);
              },
            ),
            _QuickActionItem(
              icon: Icons.lightbulb,
              label: 'Tips',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(label,
                style: AppTypography.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 12,
                )),
          ],
        ),
      ),
    );
  }
}

class _ScoreCard extends ConsumerWidget {
  const _ScoreCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scoreAsync = ref.watch(financeScoreProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: scoreAsync.when(
        data: (score) => Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.getScoreColor(score.totalScore)
                    .withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  '${score.totalScore}',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.getScoreColor(score.totalScore),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Finance Score',
                      style: AppTypography.bodyMedium.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      )),
                  const SizedBox(height: 4),
                  Text(
                    '${score.levelName}  •  ${_getScoreMessage(score.totalScore)}',
                    style: AppTypography.bodyLarge.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                context.push(AppRoutes.financeScore);
              },
              child: const Text('Improve →'),
            ),
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (_, __) => Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              ),
              child: const Icon(Icons.star, color: AppColors.warning),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Finance Score',
                      style: AppTypography.bodyMedium.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      )),
                  const SizedBox(height: 4),
                  Text(
                    'Add transactions to see your score',
                    style: AppTypography.bodyLarge.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getScoreMessage(int score) {
    if (score >= 80) return 'Outstanding!';
    if (score >= 60) return 'Doing Great!';
    if (score >= 40) return 'Good Progress';
    if (score >= 20) return 'Keep Going!';
    return 'Getting Started';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../common/widgets/cards/glass_card.dart';
import '../../common/widgets/buttons/primary_button.dart';
import '../../common/widgets/gamification/streak_counter.dart';

/// Smart Savings Hub
class SmartSavingsScreen extends StatefulWidget {
  const SmartSavingsScreen({super.key});

  @override
  State<SmartSavingsScreen> createState() => _SmartSavingsScreenState();
}

class _SmartSavingsScreenState extends State<SmartSavingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppTopBar(
        title: 'Smart Savings',
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Savings summary
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _SavingsSummaryCard(),
          ),
          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.sunset500,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTypography.labelLarge,
              tabs: const [
                Tab(text: 'Piggy Banks'),
                Tab(text: 'Challenges'),
                Tab(text: 'Round-ups'),
                Tab(text: 'Recurring'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _PiggyBanksTab(),
                _ChallengesTab(),
                _RoundUpsTab(),
                _RecurringTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewSavingSheet(context),
        backgroundColor: AppColors.sunset500,
        label: const Text('New Saving'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showNewSavingSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _NewSavingSheet(),
    );
  }
}

class _SavingsSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Saved',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹45,890',
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const StreakCounter(streak: 14),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _SavingStat(
                  label: 'This Month',
                  value: '₹8,500',
                  icon: Icons.calendar_month,
                  color: AppColors.dusk500,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SavingStat(
                  label: 'Round-ups',
                  value: '₹1,234',
                  icon: Icons.refresh,
                  color: AppColors.sunset500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SavingStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SavingStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTypography.titleSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PiggyBanksTab extends StatelessWidget {
  const _PiggyBanksTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        _PiggyBankCard(
          name: 'New Phone',
          emoji: '📱',
          target: 30000,
          saved: 18500,
          color: AppColors.dusk500,
        ),
        _PiggyBankCard(
          name: 'Birthday Gift',
          emoji: '🎁',
          target: 5000,
          saved: 3200,
          color: AppColors.sunset500,
        ),
        _PiggyBankCard(
          name: 'Trip to Goa',
          emoji: '🏖️',
          target: 25000,
          saved: 8000,
          color: AppColors.info,
        ),
      ],
    );
  }
}

class _PiggyBankCard extends StatelessWidget {
  final String name;
  final String emoji;
  final double target;
  final double saved;
  final Color color;

  const _PiggyBankCard({
    required this.name,
    required this.emoji,
    required this.target,
    required this.saved,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (saved / target).clamp(0, 1).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '₹${saved.toStringAsFixed(0)} of ₹${target.toStringAsFixed(0)}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: AppTypography.labelLarge.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.darkSurface,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text('Add Money'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChallengesTab extends StatelessWidget {
  const _ChallengesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        _ChallengeCard(
          title: '52-Week Challenge',
          description: 'Save ₹1 week 1, ₹2 week 2...',
          progress: 0.35,
          currentWeek: 18,
          totalSaved: 1530,
          xpReward: 500,
        ),
        _ChallengeCard(
          title: 'No Spend Weekend',
          description: 'Don\'t spend on weekends',
          progress: 0.5,
          currentWeek: 2,
          totalSaved: 3500,
          xpReward: 200,
          isActive: true,
        ),
        _ChallengeCard(
          title: 'Coffee Fund Redirect',
          description: 'Save what you\'d spend on coffee',
          progress: 0.8,
          currentWeek: 24,
          totalSaved: 7200,
          xpReward: 300,
        ),
      ],
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final double progress;
  final int currentWeek;
  final double totalSaved;
  final int xpReward;
  final bool isActive;

  const _ChallengeCard({
    required this.title,
    required this.description,
    required this.progress,
    required this.currentWeek,
    required this.totalSaved,
    required this.xpReward,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: isActive
            ? Border.all(color: AppColors.sunset500, width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.sunset500,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ACTIVE',
                              style: AppTypography.caption.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      description,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.dusk500.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.sunset500),
                    const SizedBox(width: 2),
                    Text(
                      '+$xpReward XP',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.sunset500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week $currentWeek',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.darkSurface,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.dusk500,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${totalSaved.toStringAsFixed(0)}',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'saved',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundUpsTab extends StatelessWidget {
  const _RoundUpsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        // Round-up settings
        _RoundUpSettingsCard(),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Recent Round-ups',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _RoundUpEntry(
          merchant: 'Swiggy',
          amount: 287,
          roundUp: 13,
          date: 'Today, 2:30 PM',
        ),
        _RoundUpEntry(
          merchant: 'Amazon',
          amount: 1,542,
          roundUp: 58,
          date: 'Yesterday',
        ),
        _RoundUpEntry(
          merchant: 'Uber',
          amount: 234,
          roundUp: 66,
          date: 'Yesterday',
        ),
      ],
    );
  }
}

class _RoundUpSettingsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Automatic Round-ups',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Round to nearest ₹100',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Switch(
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.dusk500,
              ),
            ],
          ),
          const Divider(color: AppColors.darkSurface, height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _RoundUpOption(label: '₹10', isSelected: false),
              _RoundUpOption(label: '₹50', isSelected: false),
              _RoundUpOption(label: '₹100', isSelected: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundUpOption extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _RoundUpOption({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.dusk500 : AppColors.darkSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        label,
        style: AppTypography.labelLarge.copyWith(
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _RoundUpEntry extends StatelessWidget {
  final String merchant;
  final double amount;
  final double roundUp;
  final String date;

  const _RoundUpEntry({
    required this.merchant,
    required this.amount,
    required this.roundUp,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchant,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '₹${amount.toStringAsFixed(0)} → ₹${(amount + roundUp).toStringAsFixed(0)}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+₹${roundUp.toStringAsFixed(0)}',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                date,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecurringTab extends StatelessWidget {
  const _RecurringTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        _RecurringCard(
          name: 'Monthly Savings',
          amount: 5000,
          frequency: 'Monthly',
          nextDate: '1st of every month',
          isActive: true,
        ),
        _RecurringCard(
          name: 'Emergency Fund',
          amount: 2000,
          frequency: 'Bi-weekly',
          nextDate: 'Every 15th & 30th',
          isActive: true,
        ),
        _RecurringCard(
          name: 'Vacation Fund',
          amount: 1000,
          frequency: 'Weekly',
          nextDate: 'Every Sunday',
          isActive: false,
        ),
      ],
    );
  }
}

class _RecurringCard extends StatelessWidget {
  final String name;
  final double amount;
  final String frequency;
  final String nextDate;
  final bool isActive;

  const _RecurringCard({
    required this.name,
    required this.amount,
    required this.frequency,
    required this.nextDate,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.success.withValues(alpha: 0.2)
                  : AppColors.darkSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              Icons.repeat,
              color: isActive ? AppColors.success : AppColors.textMuted,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$frequency • $nextDate',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch(
                value: isActive,
                onChanged: (value) {},
                activeColor: AppColors.success,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NewSavingSheet extends StatelessWidget {
  const _NewSavingSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Start Saving',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SavingOption(
            icon: Icons.savings,
            emoji: '🐷',
            title: 'Create Piggy Bank',
            subtitle: 'Save for a specific goal',
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: AppSpacing.sm),
          _SavingOption(
            icon: Icons.flag,
            emoji: '🎯',
            title: 'Join a Challenge',
            subtitle: 'Fun ways to save with rewards',
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: AppSpacing.sm),
          _SavingOption(
            icon: Icons.repeat,
            emoji: '🔄',
            title: 'Set Up Recurring',
            subtitle: 'Automatic savings schedule',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _SavingOption extends StatelessWidget {
  final IconData icon;
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SavingOption({
    required this.icon,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

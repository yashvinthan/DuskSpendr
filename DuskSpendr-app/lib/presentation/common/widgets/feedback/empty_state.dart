import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

/// Empty state illustration with action button
class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? customIllustration;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    this.customIllustration,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (customIllustration != null)
              customIllustration!
            else
              _EmptyStateIcon(
                icon: icon,
                color: iconColor ?? AppColors.dusk500,
              ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onAction!,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyStateIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _EmptyStateIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 48,
          color: color,
        ),
      ),
    );
  }
}

/// No transactions empty state
class NoTransactionsState extends StatelessWidget {
  final VoidCallback? onAddTransaction;

  const NoTransactionsState({
    super.key,
    this.onAddTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'No transactions yet',
      subtitle: 'Add your first transaction to start tracking your spending',
      actionLabel: 'Add Transaction',
      onAction: onAddTransaction,
      iconColor: AppColors.sunset500,
    );
  }
}

/// No budgets empty state
class NoBudgetsState extends StatelessWidget {
  final VoidCallback? onCreateBudget;

  const NoBudgetsState({
    super.key,
    this.onCreateBudget,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.pie_chart_outline,
      title: 'No budgets created',
      subtitle: 'Create a budget to manage your spending and reach your goals',
      actionLabel: 'Create Budget',
      onAction: onCreateBudget,
      iconColor: AppColors.dusk500,
    );
  }
}

/// No search results empty state
class NoSearchResultsState extends StatelessWidget {
  final String query;
  final VoidCallback? onClearSearch;

  const NoSearchResultsState({
    super.key,
    required this.query,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off_outlined,
      title: 'No results found',
      subtitle: 'We couldn\'t find anything matching "$query"',
      actionLabel: 'Clear Search',
      onAction: onClearSearch,
      iconColor: AppColors.textSecondary,
    );
  }
}

/// No linked accounts empty state
class NoAccountsState extends StatelessWidget {
  final VoidCallback? onLinkAccount;

  const NoAccountsState({
    super.key,
    this.onLinkAccount,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.account_balance_outlined,
      title: 'No accounts linked',
      subtitle: 'Connect your bank accounts for automatic transaction tracking',
      actionLabel: 'Link Account',
      onAction: onLinkAccount,
      iconColor: AppColors.info,
    );
  }
}

/// Coming soon empty state
class ComingSoonState extends StatelessWidget {
  final String feature;
  final String? description;
  final VoidCallback? onNotifyMe;

  const ComingSoonState({
    super.key,
    required this.feature,
    this.description,
    this.onNotifyMe,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.dusk500, AppColors.sunset500],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.rocket_launch_outlined,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Coming Soon',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              feature,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.dusk400,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onNotifyMe != null) ...[
              const SizedBox(height: AppSpacing.xl),
              SecondaryButton(
                label: 'Notify Me',
                icon: Icons.notifications_outlined,
                onPressed: onNotifyMe!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

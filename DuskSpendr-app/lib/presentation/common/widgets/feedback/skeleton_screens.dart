import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import 'loading.dart';

/// SS-192: Screen-specific skeleton loaders for perceived performance
/// These provide meaningful loading states that match the final content layout

/// Transaction list skeleton - shows during initial load
class TransactionListSkeleton extends StatelessWidget {
  final int itemCount;
  final bool showHeader;
  
  const TransactionListSkeleton({
    super.key,
    this.itemCount = 8,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: ShimmerLoading(width: 120, height: 20),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: itemCount,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, __) => const _TransactionItemSkeleton(),
          ),
        ),
      ],
    );
  }
}

class _TransactionItemSkeleton extends StatelessWidget {
  const _TransactionItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          // Category icon
          const ShimmerLoading(width: 48, height: 48, borderRadius: 12),
          const SizedBox(width: AppSpacing.md),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerLoading(width: 140, height: 16),
                SizedBox(height: 6),
                ShimmerLoading(width: 80, height: 12),
              ],
            ),
          ),
          // Amount
          const ShimmerLoading(width: 70, height: 18),
        ],
      ),
    );
  }
}

/// Dashboard skeleton - matches dashboard layout
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance card
          const _BalanceCardSkeleton(),
          const SizedBox(height: AppSpacing.lg),
          
          // Quick actions
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _QuickActionSkeleton(),
              _QuickActionSkeleton(),
              _QuickActionSkeleton(),
              _QuickActionSkeleton(),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Spending chart
          const ShimmerLoading(width: 120, height: 18),
          const SizedBox(height: AppSpacing.md),
          const _ChartSkeleton(),
          const SizedBox(height: AppSpacing.xl),
          
          // Recent transactions
          const ShimmerLoading(width: 160, height: 18),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(5, (_) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: _TransactionItemSkeleton(),
          )),
        ],
      ),
    );
  }
}

class _BalanceCardSkeleton extends StatelessWidget {
  const _BalanceCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.darkCard,
            AppColors.darkCard.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerLoading(width: 100, height: 14),
          SizedBox(height: AppSpacing.sm),
          ShimmerLoading(width: 180, height: 36),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BalanceStatSkeleton(),
              _BalanceStatSkeleton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceStatSkeleton extends StatelessWidget {
  const _BalanceStatSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ShimmerLoading(width: 60, height: 12),
        SizedBox(height: 4),
        ShimmerLoading(width: 90, height: 20),
      ],
    );
  }
}

class _QuickActionSkeleton extends StatelessWidget {
  const _QuickActionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ShimmerLoading(width: 56, height: 56, borderRadius: 16),
        SizedBox(height: 8),
        ShimmerLoading(width: 48, height: 10),
      ],
    );
  }
}

class _ChartSkeleton extends StatelessWidget {
  const _ChartSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          final heights = [60.0, 100.0, 80.0, 140.0, 120.0, 90.0, 70.0];
          return ShimmerLoading(
            width: 32,
            height: heights[index],
            borderRadius: 4,
          );
        }),
      ),
    );
  }
}

/// Budget list skeleton
class BudgetListSkeleton extends StatelessWidget {
  final int itemCount;
  
  const BudgetListSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, __) => const _BudgetCardSkeleton(),
    );
  }
}

class _BudgetCardSkeleton extends StatelessWidget {
  const _BudgetCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              ShimmerLoading(width: 40, height: 40, borderRadius: 10),
              SizedBox(width: AppSpacing.md),
              Expanded(child: ShimmerLoading(width: 100, height: 16)),
              ShimmerLoading(width: 80, height: 14),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const ShimmerLoading(height: 8, borderRadius: 4),
          const SizedBox(height: AppSpacing.sm),
          const ShimmerLoading(width: 120, height: 12),
        ],
      ),
    );
  }
}

/// Profile screen skeleton
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // Profile header
          const SizedBox(height: AppSpacing.xl),
          const ShimmerLoading(width: 100, height: 100, borderRadius: 50),
          const SizedBox(height: AppSpacing.md),
          const ShimmerLoading(width: 140, height: 22),
          const SizedBox(height: 6),
          const ShimmerLoading(width: 180, height: 14),
          const SizedBox(height: AppSpacing.xl),
          
          // Finance score
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: const [
                ShimmerLoading(width: 80, height: 80, borderRadius: 40),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(width: 100, height: 16),
                      SizedBox(height: 8),
                      ShimmerLoading(width: 150, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Menu items
          ...List.generate(6, (_) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: _MenuItemSkeleton(),
          )),
        ],
      ),
    );
  }
}

class _MenuItemSkeleton extends StatelessWidget {
  const _MenuItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: const [
          ShimmerLoading(width: 24, height: 24, borderRadius: 6),
          SizedBox(width: AppSpacing.md),
          Expanded(child: ShimmerLoading(width: 120, height: 16)),
          ShimmerLoading(width: 20, height: 20, borderRadius: 4),
        ],
      ),
    );
  }
}

/// Accounts list skeleton
class AccountListSkeleton extends StatelessWidget {
  final int itemCount;
  
  const AccountListSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, __) => const _AccountCardSkeleton(),
    );
  }
}

class _AccountCardSkeleton extends StatelessWidget {
  const _AccountCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          const ShimmerLoading(width: 48, height: 48, borderRadius: 12),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerLoading(width: 120, height: 16),
                SizedBox(height: 6),
                ShimmerLoading(width: 80, height: 12),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerLoading(width: 100, height: 18),
              SizedBox(height: 6),
              ShimmerLoading(width: 60, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

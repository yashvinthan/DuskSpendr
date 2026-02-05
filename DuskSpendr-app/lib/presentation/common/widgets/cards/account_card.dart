import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import 'glass_card.dart';

enum AccountStatus { connected, syncing, error, disconnected }

/// Card displaying linked account information.
class AccountCard extends StatelessWidget {
  final String accountName;
  final String accountNumber;
  final String bankName;
  final double balance;
  final AccountStatus status;
  final DateTime? lastSynced;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;
  final Widget? bankIcon;

  const AccountCard({
    super.key,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.balance,
    this.status = AccountStatus.connected,
    this.lastSynced,
    this.onTap,
    this.onMoreTap,
    this.bankIcon,
  });

  String get _maskedAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    return '****${accountNumber.substring(accountNumber.length - 4)}';
  }

  String get _statusText {
    switch (status) {
      case AccountStatus.connected:
        final synced = lastSynced;
        if (synced == null) return '✓ Connected';
        final diff = DateTime.now().difference(synced);
        if (diff.inMinutes < 5) return '✓ Synced just now';
        if (diff.inHours < 1) return '✓ Synced ${diff.inMinutes}m ago';
        return '✓ Synced ${diff.inHours}h ago';
      case AccountStatus.syncing:
        return '⟳ Syncing...';
      case AccountStatus.error:
        return '⚠ Connection error';
      case AccountStatus.disconnected:
        return '✗ Disconnected';
    }
  }

  Color get _statusColor {
    switch (status) {
      case AccountStatus.connected:
        return AppColors.success;
      case AccountStatus.syncing:
        return AppColors.dusk500;
      case AccountStatus.error:
        return AppColors.warning;
      case AccountStatus.disconnected:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Bank Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Center(
              child: bankIcon ??
                  const Icon(
                    Icons.account_balance,
                    color: AppColors.dusk500,
                    size: 24,
                  ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Account Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$bankName $accountName',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      _maskedAccountNumber,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      ' • ',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      '₹${balance.toStringAsFixed(balance.truncateToDouble() == balance ? 0 : 2)}',
                      style: AppTypography.amountSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (status == AccountStatus.syncing)
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(_statusColor),
                        ),
                      )
                    else
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(width: 6),
                    Text(
                      _statusText,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onMoreTap != null)
            IconButton(
              icon: const Icon(Icons.more_vert),
              color: AppColors.textMuted,
              onPressed: onMoreTap,
            ),
        ],
      ),
    );
  }
}

/// Chip for showing quick account summary in dashboard
class AccountChip extends StatelessWidget {
  final String bankName;
  final double balance;
  final VoidCallback? onTap;

  const AccountChip({
    super.key,
    required this.bankName,
    required this.balance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: AppColors.dusk700.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              bankName,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '₹${_formatBalance(balance)}',
              style: AppTypography.amountSmall.copyWith(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBalance(double balance) {
    if (balance >= 100000) {
      return '${(balance / 100000).toStringAsFixed(1)}L';
    } else if (balance >= 1000) {
      return '${(balance / 1000).toStringAsFixed(1)}K';
    }
    return balance.toStringAsFixed(0);
  }
}

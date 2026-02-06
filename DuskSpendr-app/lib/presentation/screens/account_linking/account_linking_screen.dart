import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../common/widgets/cards/glass_card.dart';
import '../../common/widgets/buttons/primary_button.dart';

/// Account Linking screen for connecting bank accounts via Account Aggregator
class AccountLinkingScreen extends StatefulWidget {
  const AccountLinkingScreen({super.key});

  @override
  State<AccountLinkingScreen> createState() => _AccountLinkingScreenState();
}

class _AccountLinkingScreenState extends State<AccountLinkingScreen> {
  final List<LinkedAccount> _linkedAccounts = [];
  final bool _isLinking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppTopBar(
        title: 'Linked Accounts',
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textPrimary),
            onPressed: _showPrivacyInfo,
          ),
        ],
      ),
      body: _linkedAccounts.isEmpty ? _buildEmptyState() : _buildAccountsList(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: PrimaryButton(
            label: 'Link New Account',
            icon: Icons.add,
            onPressed: _showLinkAccountSheet,
            isLoading: _isLinking,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.dusk500.withValues(alpha: 0.2),
                    AppColors.sunset500.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: const Icon(
                Icons.account_balance,
                size: 56,
                color: AppColors.dusk500,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'No Accounts Linked',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Link your bank accounts to automatically track all your transactions securely',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            _SecurityBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsList() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _TotalBalanceCard(accounts: _linkedAccounts),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Linked Accounts',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ..._linkedAccounts.map((account) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _LinkedAccountCard(
                account: account,
                onTap: () => _showAccountDetails(account),
                onSync: () => _syncAccount(account),
              ),
            )),
        const SizedBox(height: AppSpacing.lg),
        _SecurityBadge(),
      ],
    );
  }

  void _showPrivacyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Row(
          children: [
            const Icon(Icons.shield, color: AppColors.success),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Your Data is Safe',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PrivacyPoint(
              icon: Icons.lock,
              text: 'End-to-end encryption',
            ),
            _PrivacyPoint(
              icon: Icons.visibility_off,
              text: 'Read-only access - no debits possible',
            ),
            _PrivacyPoint(
              icon: Icons.verified_user,
              text: 'RBI-licensed Account Aggregator',
            ),
            _PrivacyPoint(
              icon: Icons.delete_sweep,
              text: 'Revoke access anytime',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.dusk500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLinkAccountSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _LinkAccountSheet(),
    );
  }

  void _showAccountDetails(LinkedAccount account) {
    // Navigate to account details
  }

  void _syncAccount(LinkedAccount account) {
    HapticFeedback.lightImpact();
    // Sync account data
  }
}

class LinkedAccount {
  final String id;
  final String bankName;
  final String accountType;
  final String maskedNumber;
  final double balance;
  final DateTime lastSynced;
  final Color color;

  LinkedAccount({
    required this.id,
    required this.bankName,
    required this.accountType,
    required this.maskedNumber,
    required this.balance,
    required this.lastSynced,
    required this.color,
  });
}

class _TotalBalanceCard extends StatelessWidget {
  final List<LinkedAccount> accounts;

  const _TotalBalanceCard({required this.accounts});

  @override
  Widget build(BuildContext context) {
    final total = accounts.fold<double>(
      0,
      (sum, account) => sum + account.balance,
    );

    return GlassCard(
      child: Column(
        children: [
          Text(
            'Total Balance',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '₹${_formatAmount(total)}',
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.sync,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 4),
              Text(
                'Last synced 2 min ago',
                style: AppTypography.caption.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

class _LinkedAccountCard extends StatelessWidget {
  final LinkedAccount account;
  final VoidCallback onTap;
  final VoidCallback onSync;

  const _LinkedAccountCard({
    required this.account,
    required this.onTap,
    required this.onSync,
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
          border: Border.all(
            color: account.color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: account.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                Icons.account_balance,
                color: account.color,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.bankName,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${account.accountType} • ${account.maskedNumber}',
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
                  '₹${account.balance.toStringAsFixed(0)}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: onSync,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.sync,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Sync',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user,
            color: AppColors.success,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bank-Grade Security',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.success,
                  ),
                ),
                Text(
                  'RBI regulated, 256-bit encrypted',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyPoint extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PrivacyPoint({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.success),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkAccountSheet extends StatelessWidget {
  const _LinkAccountSheet();

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
            'Link Bank Account',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Select your Account Aggregator to proceed',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _AAOption(
            name: 'Finvu',
            description: 'Most banks supported',
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: AppSpacing.sm),
          _AAOption(
            name: 'OneMoney',
            description: 'Fast linking',
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: AppSpacing.sm),
          _AAOption(
            name: 'Saafe',
            description: 'Premium experience',
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Icon(Icons.lock, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Your data is encrypted and secure. We never store bank credentials.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AAOption extends StatelessWidget {
  final String name;
  final String description;
  final VoidCallback onTap;

  const _AAOption({
    required this.name,
    required this.description,
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
          border: Border.all(color: AppColors.darkSurface),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.dusk500.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(
                Icons.security,
                color: AppColors.dusk500,
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
                    description,
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

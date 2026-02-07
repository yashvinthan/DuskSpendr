import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../common/widgets/cards/glass_card.dart';
import '../../common/widgets/buttons/primary_button.dart';
import '../../../domain/entities/linked_account.dart';
import '../../../core/linking/account_linker.dart';
import '../../../core/linking/account_linking_manager.dart';
import '../../../providers/providers.dart';

/// Account Linking screen for connecting bank accounts via Account Aggregator
class AccountLinkingScreen extends ConsumerStatefulWidget {
  const AccountLinkingScreen({super.key});

  @override
  ConsumerState<AccountLinkingScreen> createState() => _AccountLinkingScreenState();
}

class _AccountLinkingScreenState extends ConsumerState<AccountLinkingScreen> {
  bool _isLinking = false;

  @override
  Widget build(BuildContext context) {
    final linkedAccountsAsync = ref.watch(linkedAccountsProvider);

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
      body: linkedAccountsAsync.when(
        data: (accounts) => accounts.isEmpty ? _buildEmptyState() : _buildAccountsList(accounts),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
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

  Widget _buildAccountsList(List<LinkedAccount> accounts) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _TotalBalanceCard(accounts: accounts),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Linked Accounts',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...accounts.map((account) => Padding(
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

class _TotalBalanceCard extends StatelessWidget {
  final List<LinkedAccount> accounts;

  const _TotalBalanceCard({required this.accounts});

  @override
  Widget build(BuildContext context) {
    // Assuming balance is available in Money object and converting to double for display logic
    // Or reusing Money formatting if available.
    // Here we sum paisa and convert to double.
    final totalPaisa = accounts.fold<int>(
      0,
      (sum, account) => sum + (account.balance?.paisa ?? 0),
    );
    final total = totalPaisa / 100.0;

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
                'Last synced Just now',
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
    final balance = (account.balance?.paisa ?? 0) / 100.0;
    final color = account.provider.brandColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                account.type.icon,
                color: color,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.displayName,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${account.type.label} • ${account.status.label}',
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
                  '₹${balance.toStringAsFixed(0)}',
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

class _LinkAccountSheet extends ConsumerWidget {
  const _LinkAccountSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            'Link Account',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Select a provider to connect safely',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProviderOption(
            name: 'State Bank of India',
            description: 'Via AA Framework',
            icon: Icons.account_balance,
            onTap: () => _handleLinking(context, ref, AccountProviderType.sbi),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ProviderOption(
            name: 'Google Pay',
            description: 'Via UPI Integration',
            icon: Icons.payment,
            onTap: () => _handleLinking(context, ref, AccountProviderType.gpay),
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

  Future<void> _handleLinking(BuildContext context, WidgetRef ref, AccountProviderType type) async {
    Navigator.pop(context); // Close sheet

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Initiating linking for ${type.name}...')),
    );

    try {
      final manager = ref.read(accountLinkingManagerProvider);
      final result = await manager.startLinking(type);

      if (result.status == LinkingFlowStatus.failed) {
        if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${result.error}')),
          );
        }
        return;
      }

      // In a real app, we would launch result.authorizationUrl here.
      // Since we are in mock mode, we assume success and complete linking.

      // Simulate user auth delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if it was a mock URL (optional, but good for verification)
      if (result.authorizationUrl?.contains('duskspendr.mock') == true) {
        final completeResult = await manager.completeLinking(
          type: type,
          authorizationCode: 'mock_code',
          codeVerifier: result.codeVerifier,
          expectedState: result.state,
          receivedState: 'mock_state' // Needs to match what SbiBankLinker/GpayLinker returned
        );

        if (context.mounted) {
          if (completeResult.status == LinkingFlowStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account linked successfully!')),
            );
            // Invalidate provider to refresh list
            ref.invalidate(linkedAccountsProvider);
            // Also fetch transactions
             await manager.fetchTransactions(type: type);
          } else {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Linking failed: ${completeResult.error}')),
            );
          }
        }
      } else {
        // Real URL handling
        final url = Uri.parse(result.authorizationUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
           if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not launch authorization URL')),
            );
          }
        }
      }

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

class _ProviderOption extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _ProviderOption({
    required this.name,
    required this.description,
    required this.icon,
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
              child: Icon(
                icon,
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

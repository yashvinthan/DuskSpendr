import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/budget/balance_tracking_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../../providers/budget_provider.dart';

// ignore_for_file: prefer_const_constructors

/// SS-066: Low Balance Alerts UI
/// Per-account thresholds, notifications
class LowBalanceAlertsScreen extends ConsumerStatefulWidget {
  const LowBalanceAlertsScreen({super.key});

  @override
  ConsumerState<LowBalanceAlertsScreen> createState() =>
      _LowBalanceAlertsScreenState();
}

class _LowBalanceAlertsScreenState
    extends ConsumerState<LowBalanceAlertsScreen> {
  List<LowBalanceAlertEvent> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _isLoading = true);
    final balanceService = ref.read(balanceTrackingServiceProvider);
    final alerts = balanceService.getAccountsBelowThreshold();
    if (mounted) {
      setState(() {
        _alerts = alerts;
        _isLoading = false;
      });
    }
  }

  Future<void> _setThreshold(String accountId, int thresholdPaisa) async {
    final balanceService = ref.read(balanceTrackingServiceProvider);
    balanceService.setLowBalanceThreshold(accountId, thresholdPaisa);
    await _loadAlerts();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Threshold updated to ₹${thresholdPaisa / 100}'),
          backgroundColor: AppColors.darkSurface,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const AppTopBar(title: 'Low Balance Alerts'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Card(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.warning,
                            size: 32,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_alerts.length} account${_alerts.length != 1 ? 's' : ''} below threshold',
                                  style: AppTypography.bodyLarge.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Consider adding funds to avoid issues',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _alerts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                size: 64,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'All accounts are above threshold',
                                style: AppTypography.bodyLarge.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          itemCount: _alerts.length,
                          itemBuilder: (context, index) {
                            final alert = _alerts[index];
                            final deficit = alert.thresholdPaisa -
                                alert.currentBalancePaisa;
                            final percentBelow = alert.thresholdPaisa > 0
                                ? (deficit / alert.thresholdPaisa) * 100
                                : 0.0;

                            return Card(
                              color: AppColors.darkSurface,
                              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.warning.withValues(alpha: 0.2),
                                  child: Icon(
                                    Icons.account_balance_wallet,
                                    color: AppColors.warning,
                                  ),
                                ),
                                title: Text(
                                  alert.accountName,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'Current: ₹${(alert.currentBalancePaisa / 100).toStringAsFixed(2)}',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      'Threshold: ₹${(alert.thresholdPaisa / 100).toStringAsFixed(2)}',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      '₹${(deficit / 100).toStringAsFixed(2)} below threshold (${percentBelow.toStringAsFixed(1)}%)',
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  icon: const Icon(Icons.more_vert),
                                  color: AppColors.darkSurface,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: const Text('Set Threshold'),
                                      onTap: () => Future.delayed(
                                        Duration.zero,
                                        () => _showThresholdDialog(alert),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _showThresholdDialog(LowBalanceAlertEvent alert) {
    final controller = TextEditingController(
      text: (alert.thresholdPaisa / 100).toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(
          'Set Low Balance Threshold',
          style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Threshold (₹)',
            labelStyle: TextStyle(color: AppColors.textSecondary),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textMuted),
            ),
          ),
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                _setThreshold(alert.accountId, (value * 100).round());
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

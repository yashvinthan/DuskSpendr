import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../data/local/alert_settings_store.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../providers/alert_settings_provider.dart';
import '../../../providers/data_providers.dart';

class BudgetAlertsScreen extends ConsumerWidget {
  const BudgetAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(alertSettingsProvider);
    final budgetsAsync = ref.watch(budgetsProvider);
    final quietActive = _isQuietHours(settings);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientNight),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.screenVertical,
            ),
            child: ListView(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                ),
                Text('Budget Alerts',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: AppSpacing.lg),
                budgetsAsync.when(
                  data: (budgets) {
                    if (quietActive) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: Text(
                          'Quiet hours are on. Alerts will resume later.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      );
                    }

                    final alerts = budgets
                        .where((b) => b.isActive)
                        .where((b) {
                          if (b.isExceeded) return settings.alert100;
                          if (b.progress >= 0.8) return settings.alert80;
                          if (b.progress >= 0.5) return settings.alert50;
                          return false;
                        })
                        .toList();

                    if (alerts.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: Text(
                          'No active alerts right now.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: alerts
                          .map(
                            (budget) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.md),
                              child: _AlertCard(
                                title: budget.isExceeded
                                    ? '${budget.name} Budget Exceeded'
                                    : '${budget.name} Budget Alert',
                                subtitle:
                                    'Spent ${(budget.progress * 100).toStringAsFixed(0)}% of your budget.',
                                color: budget.isExceeded
                                    ? AppColors.error
                                    : AppColors.warning,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Text(
                      err.toString(),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Notification Settings',
                    style: AppTypography.h3.copyWith(
                      color: AppColors.textPrimary,
                    )),
                if (quietActive)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      'Quiet hours active. Alerts are muted.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                SwitchListTile(
                  title: const Text('50% threshold'),
                  value: settings.alert50,
                  onChanged: (value) {
                    ref
                        .read(alertSettingsProvider.notifier)
                        .update(settings.copyWith(alert50: value));
                  },
                ),
                SwitchListTile(
                  title: const Text('80% threshold'),
                  value: settings.alert80,
                  onChanged: (value) {
                    ref
                        .read(alertSettingsProvider.notifier)
                        .update(settings.copyWith(alert80: value));
                  },
                ),
                SwitchListTile(
                  title: const Text('100% threshold'),
                  value: settings.alert100,
                  onChanged: (value) {
                    ref
                        .read(alertSettingsProvider.notifier)
                        .update(settings.copyWith(alert100: value));
                  },
                ),
                SwitchListTile(
                  title: const Text('Predictive alerts'),
                  value: settings.predictiveAlerts,
                  onChanged: (value) {
                    ref
                        .read(alertSettingsProvider.notifier)
                        .update(settings.copyWith(predictiveAlerts: value));
                  },
                ),
                SwitchListTile(
                  title: const Text('Daily summary'),
                  value: settings.dailySummary,
                  onChanged: (value) {
                    ref
                        .read(alertSettingsProvider.notifier)
                        .update(settings.copyWith(dailySummary: value));
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Quiet Hours',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    )),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: _HourPicker(
                        label: 'Start',
                        value: settings.quietHoursStart,
                        onChanged: (value) {
                          ref
                              .read(alertSettingsProvider.notifier)
                              .update(settings.copyWith(quietHoursStart: value));
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _HourPicker(
                        label: 'End',
                        value: settings.quietHoursEnd,
                        onChanged: (value) {
                          ref
                              .read(alertSettingsProvider.notifier)
                              .update(settings.copyWith(quietHoursEnd: value));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () async {
                    final now = DateTime.now();
                    final scheduled = _nextAllowedTime(now, settings)
                        .add(const Duration(minutes: 1));
                    await NotificationService.instance.scheduleBudgetAlert(
                      id: 1001,
                      title: 'Budget Alert',
                      body: 'You are close to a budget limit.',
                      scheduledAt: scheduled,
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Test alert scheduled for $scheduled'),
                      ),
                    );
                  },
                  child: const Text('Schedule Test Alert'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool _isQuietHours(BudgetAlertSettings settings) {
  final now = TimeOfDay.now();
  final start = settings.quietHoursStart;
  final end = settings.quietHoursEnd;
  if (start == end) return false;
  final hour = now.hour;
  if (start < end) {
    return hour >= start && hour < end;
  }
  return hour >= start || hour < end;
}

DateTime _nextAllowedTime(DateTime now, BudgetAlertSettings settings) {
  final start = settings.quietHoursStart;
  final end = settings.quietHoursEnd;
  if (start == end) return now;
  final hour = now.hour;

  bool inQuiet;
  if (start < end) {
    inQuiet = hour >= start && hour < end;
  } else {
    inQuiet = hour >= start || hour < end;
  }
  if (!inQuiet) return now;

  final next = DateTime(now.year, now.month, now.day, end);
  if (next.isAfter(now)) return next;
  return next.add(const Duration(days: 1));
}

class _HourPicker extends StatelessWidget {
  const _HourPicker({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: value,
      dropdownColor: AppColors.darkSurface,
      decoration: InputDecoration(labelText: label),
      items: List.generate(
        24,
        (index) => DropdownMenuItem(
          value: index,
          child: Text('${index.toString().padLeft(2, '0')}:00'),
        ),
      ),
      onChanged: (value) {
        if (value == null) return;
        onChanged(value);
      },
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              )),
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              )),
        ],
      ),
    );
  }
}

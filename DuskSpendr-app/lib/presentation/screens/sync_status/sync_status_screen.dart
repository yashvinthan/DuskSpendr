import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/linking/account_linker.dart';
import '../../../../core/sync/data_synchronizer.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../../providers/sync_providers.dart';

/// SS-040: Sync Status Dashboard UI
/// Last sync time, status indicators, manual refresh
class SyncStatusScreen extends ConsumerStatefulWidget {
  const SyncStatusScreen({super.key});

  @override
  ConsumerState<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends ConsumerState<SyncStatusScreen> {
  SyncStatusInfo? _statusInfo;

  Future<void> _loadStatus() async {
    final synchronizer = ref.read(fullDataSynchronizerProvider);
    final info = await synchronizer.getSyncStatus();
    if (mounted) {
      setState(() => _statusInfo = info);
    }
  }

  Future<void> _syncNow() async {
    await ref.read(syncOrchestratorProvider.notifier).syncNow();
    await _loadStatus();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStatus());
  }

  @override
  Widget build(BuildContext context) {
    final orchestratorState = ref.watch(syncOrchestratorProvider);
    final isSyncing = orchestratorState.isSyncing;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const AppTopBar(title: 'Sync Status'),
      body: RefreshIndicator(
        onRefresh: () async {
          await _syncNow();
          await _loadStatus();
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _LastSyncCard(
              lastSyncTime: _statusInfo?.lastSyncTime ?? orchestratorState.lastApiSync,
              isSyncing: isSyncing,
              lastError: orchestratorState.lastError,
              onSyncNow: _syncNow,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_statusInfo != null) ...[
              Text(
                'Linked accounts',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ..._statusInfo!.providerStatuses.entries.map(
                (e) => _ProviderStatusTile(
                  providerType: e.key,
                  status: e.value,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LastSyncCard extends StatelessWidget {
  final DateTime? lastSyncTime;
  final bool isSyncing;
  final String? lastError;
  final VoidCallback onSyncNow;

  const _LastSyncCard({
    this.lastSyncTime,
    required this.isSyncing,
    this.lastError,
    required this.onSyncNow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.darkSurface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last sync',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (isSyncing)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  TextButton.icon(
                    onPressed: isSyncing ? null : onSyncNow,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Refresh'),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              lastSyncTime != null
                  ? DateFormat.yMMMd().add_Hm().format(lastSyncTime!)
                  : 'Never',
              style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
            ),
            if (lastError != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                lastError!,
                style: AppTypography.caption.copyWith(color: AppColors.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProviderStatusTile extends StatelessWidget {
  final AccountProviderType providerType;
  final ProviderSyncStatus status;

  const _ProviderStatusTile({
    required this.providerType,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.darkSurface,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        title: Text(
          providerType.name,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
        ),
        subtitle: Text(
          status.lastSyncTime != null
              ? 'Last sync: ${DateFormat.yMMMd().add_Hm().format(status.lastSyncTime!)}'
              : 'Not synced yet',
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
        trailing: Icon(
          status.isHealthy ? Icons.check_circle : Icons.warning_amber_rounded,
          color: status.isHealthy ? AppColors.success : AppColors.warning,
          size: 22,
        ),
      ),
    );
  }
}

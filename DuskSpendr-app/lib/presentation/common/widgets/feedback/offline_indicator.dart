import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// SS-199: Offline indicator widgets
/// Shows connectivity status and pending sync information

/// Provider for connectivity state
final connectivityProvider = StateProvider<ConnectivityState>((ref) {
  return ConnectivityState.online;
});

enum ConnectivityState {
  online,
  offline,
  syncing,
}

/// Offline banner that slides in from top when offline
class OfflineBanner extends ConsumerWidget {
  final Widget child;
  final bool showSyncCount;

  const OfflineBanner({
    super.key,
    required this.child,
    this.showSyncCount = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    final isOffline = connectivity != ConnectivityState.online;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          height: isOffline ? null : 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isOffline ? 1.0 : 0.0,
            child: _OfflineBannerContent(
              state: connectivity,
              showSyncCount: showSyncCount,
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _OfflineBannerContent extends StatelessWidget {
  final ConnectivityState state;
  final bool showSyncCount;

  const _OfflineBannerContent({
    required this.state,
    required this.showSyncCount,
  });

  @override
  Widget build(BuildContext context) {
    final isSyncing = state == ConnectivityState.syncing;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: MediaQuery.of(context).padding.top + AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isSyncing ? AppColors.info : AppColors.warning,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isSyncing)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else
            const Icon(Icons.wifi_off, color: Colors.white, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              isSyncing ? 'Syncing changes...' : 'You\'re offline',
              style: AppTypography.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (!isSyncing && showSyncCount)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                '3 pending',
                style: AppTypography.caption.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Small offline indicator dot for compact display
class OfflineDot extends ConsumerWidget {
  final double size;
  
  const OfflineDot({super.key, this.size = 8});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getColor(connectivity),
        boxShadow: [
          BoxShadow(
            color: _getColor(connectivity).withOpacity(0.4),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  Color _getColor(ConnectivityState state) {
    switch (state) {
      case ConnectivityState.online:
        return AppColors.success;
      case ConnectivityState.offline:
        return AppColors.error;
      case ConnectivityState.syncing:
        return AppColors.info;
    }
  }
}

/// Offline status bar for AppBar
class OfflineStatusChip extends ConsumerWidget {
  const OfflineStatusChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    
    if (connectivity == ConnectivityState.online) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: connectivity == ConnectivityState.syncing
            ? AppColors.info.withOpacity(0.2)
            : AppColors.warning.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: connectivity == ConnectivityState.syncing
              ? AppColors.info.withOpacity(0.4)
              : AppColors.warning.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (connectivity == ConnectivityState.syncing)
            const SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.info),
              ),
            )
          else
            const Icon(Icons.wifi_off, size: 12, color: AppColors.warning),
          const SizedBox(width: 4),
          Text(
            connectivity == ConnectivityState.syncing ? 'Syncing' : 'Offline',
            style: AppTypography.caption.copyWith(
              color: connectivity == ConnectivityState.syncing
                  ? AppColors.info
                  : AppColors.warning,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full offline screen overlay
class OfflineOverlay extends ConsumerWidget {
  final Widget child;
  final Widget? offlineWidget;
  final bool allowInteraction;

  const OfflineOverlay({
    super.key,
    required this.child,
    this.offlineWidget,
    this.allowInteraction = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    final isOffline = connectivity == ConnectivityState.offline;

    return Stack(
      children: [
        child,
        if (isOffline && !allowInteraction)
          Positioned.fill(
            child: Container(
              color: AppColors.darkBackground.withOpacity(0.9),
              child: offlineWidget ?? const _DefaultOfflineContent(),
            ),
          ),
      ],
    );
  }
}

class _DefaultOfflineContent extends StatelessWidget {
  const _DefaultOfflineContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off,
                size: 40,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Internet Connection',
              style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'This feature requires an internet connection. Please check your connection and try again.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.warning,
                side: const BorderSide(color: AppColors.warning),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sync status indicator with pending changes count
class SyncStatusIndicator extends ConsumerWidget {
  final int pendingCount;
  
  const SyncStatusIndicator({super.key, this.pendingCount = 0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: _getBorderColor(connectivity)),
      ),
      child: Row(
        children: [
          _buildIcon(connectivity),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(connectivity),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _getSubtitle(connectivity, pendingCount),
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          if (pendingCount > 0 && connectivity == ConnectivityState.offline)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  pendingCount.toString(),
                  style: AppTypography.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIcon(ConnectivityState state) {
    switch (state) {
      case ConnectivityState.online:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.cloud_done, color: AppColors.success, size: 20),
        );
      case ConnectivityState.offline:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.cloud_off, color: AppColors.warning, size: 20),
        );
      case ConnectivityState.syncing:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.info),
            ),
          ),
        );
    }
  }

  Color _getBorderColor(ConnectivityState state) {
    switch (state) {
      case ConnectivityState.online:
        return AppColors.success.withOpacity(0.3);
      case ConnectivityState.offline:
        return AppColors.warning.withOpacity(0.3);
      case ConnectivityState.syncing:
        return AppColors.info.withOpacity(0.3);
    }
  }

  String _getTitle(ConnectivityState state) {
    switch (state) {
      case ConnectivityState.online:
        return 'All synced';
      case ConnectivityState.offline:
        return 'Offline mode';
      case ConnectivityState.syncing:
        return 'Syncing...';
    }
  }

  String _getSubtitle(ConnectivityState state, int pending) {
    switch (state) {
      case ConnectivityState.online:
        return 'Your data is up to date';
      case ConnectivityState.offline:
        return pending > 0 ? '$pending change${pending > 1 ? 's' : ''} pending' : 'Working offline';
      case ConnectivityState.syncing:
        return 'Uploading your changes';
    }
  }
}

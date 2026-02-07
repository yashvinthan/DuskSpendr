import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../providers/investing_providers.dart';
import '../../../../domain/entities/investing/portfolio_summary.dart';
import '../widgets/portfolio_summary_card.dart';
import '../widgets/asset_allocation_chart.dart';

class PortfolioDashboardView extends ConsumerWidget {
  const PortfolioDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(portfolioSummaryProvider);

    return summaryAsync.when(
      data: (summary) => _buildBody(context, summary),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
    );
  }

  Widget _buildBody(BuildContext context, PortfolioSummary summary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Portfolio Summary Card
          PortfolioSummaryCard(summary: summary),
          const SizedBox(height: AppSpacing.lg),

          // Asset Allocation Chart
          Text(
            'Asset Allocation',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AssetAllocationChart(allocation: summary.allocation),
          const SizedBox(height: AppSpacing.lg),

          // Upcoming Events
          if (summary.upcomingEvents.isNotEmpty) ...[
            Text(
              'Upcoming',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...summary.upcomingEvents.map((event) => _UpcomingEventTile(event: event)),
          ],
        ],
      ),
    );
  }
}

class _UpcomingEventTile extends StatelessWidget {
  final UpcomingEvent event;

  const _UpcomingEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border(
          left: BorderSide(
            color: _getColorForEventType(event.type),
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${event.date.day}/${event.date.month}/${event.date.year}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            event.amount.formatted,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForEventType(EventType type) {
    switch (type) {
      case EventType.sip:
        return AppColors.dusk500;
      case EventType.fdMaturity:
        return AppColors.success;
      case EventType.dividend:
        return AppColors.gold500;
      default:
        return AppColors.textSecondary;
    }
  }
}

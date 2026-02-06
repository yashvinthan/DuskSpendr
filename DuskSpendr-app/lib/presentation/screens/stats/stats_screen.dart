import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../data/models/transaction_model.dart';
import '../../../providers/data_providers.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(transactionsProvider);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradientNight),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.screenVertical,
          ),
          child: asyncItems.when(
            data: (items) {
              final now = DateTime.now();
              final weekStart = now.subtract(const Duration(days: 6));
              final weekItems = items.where((tx) => tx.timestamp.isAfter(
                    DateTime(weekStart.year, weekStart.month, weekStart.day),
                  ));
              final total = weekItems
                  .where((tx) => tx.type != 'credit')
                  .fold<double>(0, (sum, tx) => sum + tx.amountPaisa / 100.0);
              final previousStart = weekStart.subtract(const Duration(days: 7));
              final previousItems = items.where((tx) {
                return tx.timestamp.isAfter(
                      DateTime(
                          previousStart.year, previousStart.month, previousStart.day),
                    ) &&
                    tx.timestamp.isBefore(
                      DateTime(weekStart.year, weekStart.month, weekStart.day),
                    );
              });
              final previousTotal = previousItems
                  .where((tx) => tx.type != 'credit')
                  .fold<double>(0, (sum, tx) => sum + tx.amountPaisa / 100.0);
              final diff = previousTotal == 0
                  ? 0.0
                  : ((total - previousTotal) / previousTotal) * 100;

              final spots = _buildWeekSpots(items);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Analytics',
                      style: AppTypography.h2.copyWith(
                        color: AppColors.textPrimary,
                      )),
                  const SizedBox(height: AppSpacing.lg),
                  _TotalSpentCard(total: total, diff: diff),
                  const SizedBox(height: AppSpacing.lg),
                  _LineChartCard(spots: spots),
                  const SizedBox(height: AppSpacing.lg),
                  _CategoryLegend(),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Text(
                err.toString(),
                style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TotalSpentCard extends StatelessWidget {
  const _TotalSpentCard({required this.total, required this.diff});

  final double total;
  final double diff;

  @override
  Widget build(BuildContext context) {
    final diffLabel = diff == 0
        ? 'No change vs last week'
        : '${diff.isNegative ? '▼' : '▲'} ${diff.abs().toStringAsFixed(1)}% vs last week';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Spent',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              )),
          const SizedBox(height: AppSpacing.sm),
          Text('₹${total.toStringAsFixed(0)}',
              style: AppTypography.displayLarge.copyWith(
                fontSize: 32,
                color: AppColors.textPrimary,
              )),
          const SizedBox(height: AppSpacing.xs),
          Text(diffLabel,
              style: AppTypography.bodyMedium.copyWith(
                color: diff.isNegative ? AppColors.warning : AppColors.success,
              )),
        ],
      ),
    );
  }
}

class _LineChartCard extends StatelessWidget {
  const _LineChartCard({required this.spots});

  final List<FlSpot> spots;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Spending Trend',
              style: AppTypography.h3.copyWith(
                color: AppColors.textPrimary,
              )),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: AppColors.sunset500,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.sunset500.withValues(alpha: 0.4),
                          AppColors.dusk500.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    spots: spots,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _LegendItem(label: 'Food 34%', color: AppColors.categoryFood),
        _LegendItem(label: 'Transport 17%', color: AppColors.categoryTransport),
        _LegendItem(
            label: 'Entertainment 25%', color: AppColors.categoryEntertainment),
        _LegendItem(label: 'Education 12%', color: AppColors.categoryEducation),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            )),
      ],
    );
  }
}

List<FlSpot> _buildWeekSpots(List<TransactionModel> items) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day)
      .subtract(const Duration(days: 6));
  final totals = List<double>.filled(7, 0);

  for (final tx in items) {
    if (tx.type == 'credit') continue;
    final day = DateTime(tx.timestamp.year, tx.timestamp.month, tx.timestamp.day);
    if (day.isBefore(start)) continue;
    final index = day.difference(start).inDays;
    if (index >= 0 && index < 7) {
      totals[index] += tx.amountPaisa / 100;
    }
  }

  return List.generate(7, (i) => FlSpot(i.toDouble(), totals[i]));
}


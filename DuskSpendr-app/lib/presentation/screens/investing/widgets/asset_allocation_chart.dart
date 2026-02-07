import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../domain/entities/investing/asset_class.dart';

class AssetAllocationChart extends StatefulWidget {
  final Map<AssetClass, double> allocation;

  const AssetAllocationChart({super.key, required this.allocation});

  @override
  State<AssetAllocationChart> createState() => _AssetAllocationChartState();
}

class _AssetAllocationChartState extends State<AssetAllocationChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _showingSections(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: widget.allocation.entries.map((entry) {
            return _Indicator(
              color: _getColorForAssetClass(entry.key),
              text: _getNameForAssetClass(entry.key),
              value: '${entry.value}%',
              isSquare: false,
            );
          }).toList(),
        ),
      ],
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(widget.allocation.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      final entry = widget.allocation.entries.elementAt(i);
      final value = entry.value;

      return PieChartSectionData(
        color: _getColorForAssetClass(entry.key),
        value: value,
        title: '$value%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      );
    });
  }

  Color _getColorForAssetClass(AssetClass assetClass) {
    switch (assetClass) {
      case AssetClass.equity:
        return AppColors.dusk500;
      case AssetClass.mutualFund:
        return AppColors.sunset500;
      case AssetClass.fixedDeposit:
        return AppColors.success;
      case AssetClass.gold:
        return AppColors.warning;
      case AssetClass.savings:
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getNameForAssetClass(AssetClass assetClass) {
    switch (assetClass) {
      case AssetClass.equity:
        return 'Equity';
      case AssetClass.mutualFund:
        return 'Mutual Funds';
      case AssetClass.fixedDeposit:
        return 'FDs';
      case AssetClass.gold:
        return 'Gold';
      case AssetClass.savings:
        return 'Savings';
      default:
        return 'Other';
    }
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final String value;
  final bool isSquare;

  const _Indicator({
    required this.color,
    required this.text,
    required this.value,
    required this.isSquare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        )
      ],
    );
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// Data model for chart segments
class ChartSegment {
  final String label;
  final double value;
  final Color color;
  final String? emoji;

  const ChartSegment({
    required this.label,
    required this.value,
    required this.color,
    this.emoji,
  });

  double getPercentage(double total) {
    if (total == 0) return 0;
    return (value / total * 100);
  }
}

/// Animated donut chart for category distribution
class DonutChart extends StatefulWidget {
  final List<ChartSegment> segments;
  final double size;
  final double strokeWidth;
  final Widget? centerContent;
  final Duration animationDuration;
  final ValueChanged<int?>? onSegmentTapped;
  final int? selectedIndex;

  const DonutChart({
    super.key,
    required this.segments,
    this.size = 200,
    this.strokeWidth = 24,
    this.centerContent,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.onSegmentTapped,
    this.selectedIndex,
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _total => widget.segments.fold(0, (sum, s) => sum + s.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _DonutPainter(
                      segments: widget.segments,
                      animationValue: _animation.value,
                      strokeWidth: widget.strokeWidth,
                      selectedIndex: widget.selectedIndex,
                    ),
                  ),
                  if (widget.centerContent != null) widget.centerContent!,
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      alignment: WrapAlignment.center,
      children: widget.segments.asMap().entries.map((entry) {
        final index = entry.key;
        final segment = entry.value;
        final percentage = segment.getPercentage(_total);
        final isSelected = widget.selectedIndex == index;

        return GestureDetector(
          onTap: () => widget.onSegmentTapped?.call(isSelected ? null : index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? segment.color.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: segment.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                if (segment.emoji != null) ...[
                  Text(segment.emoji!, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                ],
                Text(
                  '${segment.label} ${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<ChartSegment> segments;
  final double animationValue;
  final double strokeWidth;
  final int? selectedIndex;

  _DonutPainter({
    required this.segments,
    required this.animationValue,
    required this.strokeWidth,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final total = segments.fold<double>(0, (sum, s) => sum + s.value);

    if (total == 0) return;

    double startAngle = -math.pi / 2; // Start from top

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final sweepAngle = (segment.value / total) * 2 * math.pi * animationValue;
      final isSelected = selectedIndex == i;

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? strokeWidth + 4 : strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle - 0.02, // Small gap between segments
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}

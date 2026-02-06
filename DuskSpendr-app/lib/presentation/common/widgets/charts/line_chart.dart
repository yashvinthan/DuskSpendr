import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

/// Data point for line chart
class LineChartPoint {
  final DateTime date;
  final double value;
  final String? label;

  const LineChartPoint({
    required this.date,
    required this.value,
    this.label,
  });
}

/// Animated line chart for spending trends
class SpendingLineChart extends StatefulWidget {
  final List<LineChartPoint> points;
  final double height;
  final Color lineColor;
  final bool showGradient;
  final bool showDots;
  final bool animated;
  final ValueChanged<LineChartPoint?>? onPointSelected;

  const SpendingLineChart({
    super.key,
    required this.points,
    this.height = 200,
    this.lineColor = AppColors.dusk500,
    this.showGradient = true,
    this.showDots = true,
    this.animated = true,
    this.onPointSelected,
  });

  @override
  State<SpendingLineChart> createState() => _SpendingLineChartState();
}

class _SpendingLineChartState extends State<SpendingLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    if (widget.animated) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _maxValue {
    if (widget.points.isEmpty) return 100;
    return widget.points.map((p) => p.value).reduce(math.max);
  }

  double get _minValue {
    if (widget.points.isEmpty) return 0;
    return widget.points.map((p) => p.value).reduce(math.min);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: Text(
            'No data available',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return GestureDetector(
            onTapDown: (details) => _handleTap(details.localPosition),
            child: CustomPaint(
              size: Size(double.infinity, widget.height),
              painter: _LineChartPainter(
                points: widget.points,
                animationValue: _animation.value,
                lineColor: widget.lineColor,
                showGradient: widget.showGradient,
                showDots: widget.showDots,
                selectedIndex: _selectedIndex,
                maxValue: _maxValue,
                minValue: _minValue,
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleTap(Offset position) {
    if (widget.points.isEmpty) return;

    final width = context.size?.width ?? 0;
    final segmentWidth = width / (widget.points.length - 1);
    final index = (position.dx / segmentWidth).round().clamp(0, widget.points.length - 1);

    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = null;
        widget.onPointSelected?.call(null);
      } else {
        _selectedIndex = index;
        widget.onPointSelected?.call(widget.points[index]);
      }
    });
  }
}

class _LineChartPainter extends CustomPainter {
  final List<LineChartPoint> points;
  final double animationValue;
  final Color lineColor;
  final bool showGradient;
  final bool showDots;
  final int? selectedIndex;
  final double maxValue;
  final double minValue;

  _LineChartPainter({
    required this.points,
    required this.animationValue,
    required this.lineColor,
    required this.showGradient,
    required this.showDots,
    this.selectedIndex,
    required this.maxValue,
    required this.minValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const padding = EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 24);
    final chartRect = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );

    final range = maxValue - minValue;
    final normalizedRange = range == 0 ? 1.0 : range;

    // Calculate points
    final path = Path();
    final gradientPath = Path();
    final dotPositions = <Offset>[];

    for (int i = 0; i < points.length; i++) {
      final x = chartRect.left + (i / (points.length - 1)) * chartRect.width;
      final normalizedValue = (points[i].value - minValue) / normalizedRange;
      final y = chartRect.bottom - (normalizedValue * chartRect.height);

      final animatedY = chartRect.bottom - ((chartRect.bottom - y) * animationValue);

      if (i == 0) {
        path.moveTo(x, animatedY);
        gradientPath.moveTo(x, chartRect.bottom);
        gradientPath.lineTo(x, animatedY);
      } else {
        path.lineTo(x, animatedY);
        gradientPath.lineTo(x, animatedY);
      }

      dotPositions.add(Offset(x, animatedY));
    }

    // Complete gradient path
    gradientPath.lineTo(chartRect.right, chartRect.bottom);
    gradientPath.close();

    // Draw gradient fill
    if (showGradient) {
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            lineColor.withValues(alpha: 0.3 * animationValue),
            lineColor.withValues(alpha: 0.0),
          ],
        ).createShader(chartRect);

      canvas.drawPath(gradientPath, gradientPaint);
    }

    // Draw line
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    // Draw dots
    if (showDots) {
      for (int i = 0; i < dotPositions.length; i++) {
        final isSelected = selectedIndex == i;
        final dotPaint = Paint()
          ..color = isSelected ? lineColor : AppColors.darkCard
          ..style = PaintingStyle.fill;

        final borderPaint = Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        final radius = isSelected ? 8.0 : 5.0;
        canvas.drawCircle(dotPositions[i], radius, dotPaint);
        canvas.drawCircle(dotPositions[i], radius, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}

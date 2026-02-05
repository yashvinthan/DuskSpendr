import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// Animated progress bar for budgets and goals.
class ProgressBar extends StatefulWidget {
  final double value;
  final double maxValue;
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final bool animated;
  final bool showPercentage;
  final Duration animationDuration;
  final Gradient? gradient;

  const ProgressBar({
    super.key,
    required this.value,
    this.maxValue = 100,
    this.color,
    this.backgroundColor,
    this.height = 8,
    this.animated = true,
    this.showPercentage = false,
    this.animationDuration = const Duration(milliseconds: 800),
    this.gradient,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double get _percentage => widget.maxValue > 0
      ? (widget.value / widget.maxValue).clamp(0, 1)
      : 0;

  Color get _progressColor {
    if (widget.color != null) return widget.color!;
    if (_percentage >= 1.0) return AppColors.error;
    if (_percentage >= 0.8) return AppColors.warning;
    return AppColors.dusk500;
  }

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
    if (widget.animated) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.animated) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(widget.height / 2),
                child: Stack(
                  children: [
                    Container(
                      height: widget.height,
                      color: widget.backgroundColor ?? AppColors.darkSurface,
                    ),
                    FractionallySizedBox(
                      widthFactor: _percentage * _animation.value,
                      child: Container(
                        height: widget.height,
                        decoration: BoxDecoration(
                          color: widget.gradient == null ? _progressColor : null,
                          gradient: widget.gradient ??
                              LinearGradient(
                                colors: [
                                  _progressColor,
                                  _progressColor.withValues(alpha: 0.8),
                                ],
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (widget.showPercentage) ...[
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 40,
            child: Text(
              '${(_percentage * 100).toStringAsFixed(0)}%',
              style: AppTypography.amountSmall.copyWith(
                color: _progressColor,
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ],
    );
  }
}

/// Mini progress bars for category breakdown on dashboard
class MiniCategoryBar extends StatelessWidget {
  final String label;
  final String? emoji;
  final double amount;
  final double maxAmount;
  final Color color;
  final VoidCallback? onTap;

  const MiniCategoryBar({
    super.key,
    required this.label,
    this.emoji,
    required this.amount,
    required this.maxAmount,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = maxAmount > 0 ? (amount / maxAmount).clamp(0, 1.0) : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                emoji ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            SizedBox(
              width: 80,
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Stack(
                  children: [
                    Container(
                      height: 4,
                      color: AppColors.darkSurface,
                    ),
                    FractionallySizedBox(
                      widthFactor: percentage,
                      child: Container(
                        height: 4,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 60,
              child: Text(
                '₹${amount.toStringAsFixed(0)}',
                style: AppTypography.amountSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular progress ring for gamification
class ProgressRing extends StatefulWidget {
  final double value;
  final double maxValue;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? child;
  final bool animated;
  final Gradient? gradient;

  const ProgressRing({
    super.key,
    required this.value,
    this.maxValue = 100,
    this.size = 100,
    this.strokeWidth = 8,
    this.progressColor,
    this.backgroundColor,
    this.child,
    this.animated = true,
    this.gradient,
  });

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

  double get _percentage => widget.maxValue > 0
      ? (widget.value / widget.maxValue).clamp(0, 1)
      : 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _RingPainter(
                  percentage: _percentage * _animation.value,
                  strokeWidth: widget.strokeWidth,
                  progressColor: widget.progressColor ?? AppColors.dusk500,
                  backgroundColor:
                      widget.backgroundColor ?? AppColors.darkSurface,
                ),
              ),
              if (widget.child != null) widget.child!,
            ],
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;

  _RingPainter({
    required this.percentage,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background ring
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}

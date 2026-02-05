import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// Animated finance score gauge with gradient arc
class ScoreGauge extends StatefulWidget {
  final int score;
  final int maxScore;
  final String label;
  final bool animate;

  const ScoreGauge({
    super.key,
    required this.score,
    this.maxScore = 850,
    this.label = 'Finance Score',
    this.animate = true,
  });

  @override
  State<ScoreGauge> createState() => _ScoreGaugeState();
}

class _ScoreGaugeState extends State<ScoreGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    if (widget.animate) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(ScoreGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.score != oldWidget.score && widget.animate) {
      _controller.forward(from: 0);
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getScoreColor(int score) {
    if (score >= 750) return AppColors.success;
    if (score >= 650) return AppColors.dusk500;
    if (score >= 550) return AppColors.warning;
    return AppColors.error;
  }

  String _getScoreLabel(int score) {
    if (score >= 750) return 'Excellent';
    if (score >= 650) return 'Good';
    if (score >= 550) return 'Fair';
    return 'Needs Work';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final animatedScore =
            (widget.score * _animation.value).round();
        final progress = animatedScore / widget.maxScore;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(200, 120),
                    painter: _GaugePainter(
                      progress: progress.clamp(0, 1),
                      scoreColor: _getScoreColor(animatedScore),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Column(
                      children: [
                        Text(
                          animatedScore.toString(),
                          style: AppTypography.displayMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getScoreLabel(animatedScore),
                          style: AppTypography.bodyMedium.copyWith(
                            color: _getScoreColor(animatedScore),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color scoreColor;

  _GaugePainter({
    required this.progress,
    required this.scoreColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    const radius = 90.0;
    const strokeWidth = 12.0;

    // Background arc
    final bgPaint = Paint()
      ..color = AppColors.darkCard
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Progress arc with gradient
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: math.pi,
        endAngle: 2 * math.pi,
        colors: [AppColors.dusk600, scoreColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * progress,
      false,
      progressPaint,
    );

    // Score indicator dot
    if (progress > 0) {
      final angle = math.pi + (math.pi * progress);
      final indicatorX = center.dx + radius * math.cos(angle);
      final indicatorY = center.dy + radius * math.sin(angle);

      canvas.drawCircle(
        Offset(indicatorX, indicatorY),
        8,
        Paint()..color = scoreColor,
      );
      canvas.drawCircle(
        Offset(indicatorX, indicatorY),
        5,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.scoreColor != scoreColor;
}

/// Mini score widget for compact display
class MiniScoreGauge extends StatelessWidget {
  final int score;
  final int maxScore;
  final double size;

  const MiniScoreGauge({
    super.key,
    required this.score,
    this.maxScore = 850,
    this.size = 60,
  });

  Color get _color {
    if (score >= 750) return AppColors.success;
    if (score >= 650) return AppColors.dusk500;
    if (score >= 550) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (score / maxScore).clamp(0, 1).toDouble();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 4,
              backgroundColor: AppColors.darkCard,
              valueColor: AlwaysStoppedAnimation<Color>(_color),
            ),
          ),
          Text(
            score.toString(),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.22,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// Streak counter with fire animation
class StreakCounter extends StatefulWidget {
  final int streak;
  final String label;
  final bool animate;

  const StreakCounter({
    super.key,
    required this.streak,
    this.label = 'Day Streak',
    this.animate = true,
  });

  @override
  State<StreakCounter> createState() => _StreakCounterState();
}

class _StreakCounterState extends State<StreakCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(StreakCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.streak != oldWidget.streak && widget.animate) {
      HapticFeedback.mediumImpact();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _streakColor {
    if (widget.streak >= 30) return AppColors.sunset500;
    if (widget.streak >= 7) return AppColors.warning;
    return AppColors.dusk500;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              gradient: LinearGradient(
                colors: [
                  _streakColor.withValues(alpha: 0.2),
                  _streakColor.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: _streakColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _streakColor.withValues(alpha: 0.2),
                  ),
                  child: Center(
                    child: Text(
                      '🔥',
                      style: TextStyle(fontSize: 20 + (4 * _bounceAnimation.value)),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.streak}',
                      style: AppTypography.headlineSmall.copyWith(
                        color: _streakColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.label,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// XP progress bar with level indicator
class XPProgressBar extends StatefulWidget {
  final int currentXP;
  final int xpForNextLevel;
  final int level;
  final bool animate;

  const XPProgressBar({
    super.key,
    required this.currentXP,
    required this.xpForNextLevel,
    required this.level,
    this.animate = true,
  });

  @override
  State<XPProgressBar> createState() => _XPProgressBarState();
}

class _XPProgressBarState extends State<XPProgressBar>
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
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    if (widget.animate) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(XPProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentXP != oldWidget.currentXP && widget.animate) {
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
    final progress = (widget.currentXP / widget.xpForNextLevel).clamp(0, 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                LevelBadge(level: widget.level),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Level ${widget.level}',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              '${widget.currentXP}/${widget.xpForNextLevel} XP',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.darkCard,
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: progress * _animation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: const LinearGradient(
                          colors: [AppColors.dusk500, AppColors.sunset500],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.dusk500.withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (progress * _animation.value > 0.05)
                    Positioned(
                      right: 4,
                      top: 2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Level badge with star decoration
class LevelBadge extends StatelessWidget {
  final int level;
  final double size;

  const LevelBadge({
    super.key,
    required this.level,
    this.size = 32,
  });

  Color get _badgeColor {
    if (level >= 50) return AppColors.sunset500;
    if (level >= 25) return AppColors.dusk500;
    if (level >= 10) return AppColors.success;
    return AppColors.info;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _badgeColor,
            _badgeColor.withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _badgeColor.withValues(alpha: 0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: Text(
          level.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Daily challenge card
class DailyChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final int xpReward;
  final double progress;
  final bool isCompleted;
  final VoidCallback? onTap;

  const DailyChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.xpReward,
    this.progress = 0,
    this.isCompleted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCompleted ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          color: AppColors.darkCard,
          border: Border.all(
            color: isCompleted
                ? AppColors.success.withValues(alpha: 0.5)
                : AppColors.dusk500.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: isCompleted
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.dusk500.withValues(alpha: 0.2),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: AppColors.success, size: 28)
                    : Icon(icon, color: AppColors.dusk500, size: 24),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (!isCompleted && progress > 0) ...[
                    const SizedBox(height: AppSpacing.xs),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.darkSurface,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.dusk500,
                      ),
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                color: AppColors.sunset500.withValues(alpha: 0.2),
              ),
              child: Text(
                '+$xpReward XP',
                style: AppTypography.caption.copyWith(
                  color: AppColors.sunset500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

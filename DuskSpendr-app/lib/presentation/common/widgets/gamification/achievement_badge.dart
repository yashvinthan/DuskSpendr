import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// Achievement badge with unlock animation
class AchievementBadge extends StatefulWidget {
  final String name;
  final String? description;
  final IconData icon;
  final Color? color;
  final bool isUnlocked;
  final int? progress;
  final int? maxProgress;
  final VoidCallback? onTap;
  final BadgeSize size;

  const AchievementBadge({
    super.key,
    required this.name,
    this.description,
    required this.icon,
    this.color,
    this.isUnlocked = false,
    this.progress,
    this.maxProgress,
    this.onTap,
    this.size = BadgeSize.medium,
  });

  @override
  State<AchievementBadge> createState() => _AchievementBadgeState();
}

enum BadgeSize { small, medium, large }

class _AchievementBadgeState extends State<AchievementBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.isUnlocked) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AchievementBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isUnlocked && !oldWidget.isUnlocked) {
      HapticFeedback.heavyImpact();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _badgeSize {
    switch (widget.size) {
      case BadgeSize.small:
        return 48;
      case BadgeSize.medium:
        return 72;
      case BadgeSize.large:
        return 96;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case BadgeSize.small:
        return 24;
      case BadgeSize.medium:
        return 32;
      case BadgeSize.large:
        return 44;
    }
  }

  Color get _badgeColor => widget.color ?? AppColors.dusk500;

  @override
  Widget build(BuildContext context) {
    final hasProgress =
        widget.progress != null && widget.maxProgress != null;
    final progressValue = hasProgress
        ? (widget.progress! / widget.maxProgress!).clamp(0, 1).toDouble()
        : 0.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isUnlocked ? _scaleAnimation.value : 1.0,
                child: Container(
                  width: _badgeSize,
                  height: _badgeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: widget.isUnlocked
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _badgeColor,
                              _badgeColor.withValues(alpha: 0.7),
                            ],
                          )
                        : null,
                    color: widget.isUnlocked
                        ? null
                        : AppColors.darkCard,
                    boxShadow: widget.isUnlocked
                        ? [
                            BoxShadow(
                              color: _badgeColor
                                  .withValues(alpha: 0.4 * _glowAnimation.value),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (hasProgress && !widget.isUnlocked)
                        SizedBox(
                          width: _badgeSize,
                          height: _badgeSize,
                          child: CircularProgressIndicator(
                            value: progressValue,
                            strokeWidth: 3,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _badgeColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      Icon(
                        widget.icon,
                        size: _iconSize,
                        color: widget.isUnlocked
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                      if (!widget.isUnlocked)
                        Container(
                          width: _badgeSize,
                          height: _badgeSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.darkBackground.withValues(alpha: 0.3),
                          ),
                          child: Icon(
                            Icons.lock,
                            size: _iconSize * 0.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (widget.size != BadgeSize.small) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.name,
              style: AppTypography.caption.copyWith(
                color: widget.isUnlocked
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: widget.isUnlocked ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (hasProgress && !widget.isUnlocked) ...[
              const SizedBox(height: 2),
              Text(
                '${widget.progress}/${widget.maxProgress}',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// Achievement badge grid
class AchievementGrid extends StatelessWidget {
  final List<AchievementBadge> badges;
  final int crossAxisCount;
  final double spacing;

  const AchievementGrid({
    super.key,
    required this.badges,
    this.crossAxisCount = 4,
    this.spacing = AppSpacing.md,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 0.8,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) => badges[index],
    );
  }
}

/// Achievement unlock popup
class AchievementUnlockPopup extends StatefulWidget {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onDismiss;

  const AchievementUnlockPopup({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    this.color = AppColors.dusk500,
    this.onDismiss,
  });

  @override
  State<AchievementUnlockPopup> createState() => _AchievementUnlockPopupState();
}

class _AchievementUnlockPopupState extends State<AchievementUnlockPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    HapticFeedback.heavyImpact();
    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) _dismiss();
    });
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onDismiss?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: widget.color.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🎉 Achievement Unlocked!',
                    style: AppTypography.titleMedium.copyWith(
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          widget.color,
                          widget.color.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    widget.name,
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

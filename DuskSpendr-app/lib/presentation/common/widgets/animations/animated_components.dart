import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// SS-189: Animated components for micro-interactions and gamification

/// Animated counter that smoothly transitions between values
class AnimatedCounter extends StatelessWidget {
  final double value;
  final String prefix;
  final String suffix;
  final int decimals;
  final TextStyle? style;
  final Color? positiveColor;
  final Color? negativeColor;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.decimals = 0,
    this.style,
    this.positiveColor,
    this.negativeColor,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        final isNegative = animatedValue < 0;
        final displayValue = animatedValue.abs().toStringAsFixed(decimals);
        
        return Text(
          '$prefix${isNegative ? "-" : ""}$displayValue$suffix',
          style: (style ?? AppTypography.amount).copyWith(
            color: isNegative 
                ? (negativeColor ?? AppColors.error)
                : (positiveColor ?? AppColors.success),
          ),
        );
      },
    );
  }
}

/// Animated progress bar with smooth fill animation
class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final BorderRadius? borderRadius;
  final Duration duration;
  final bool showPercentage;
  final Widget? leading;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 8,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 600),
    this.showPercentage = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final radius = borderRadius ?? BorderRadius.circular(height / 2);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leading!,
              if (showPercentage)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: clampedProgress),
                  duration: duration,
                  builder: (context, value, _) {
                    return Text(
                      '${(value * 100).toInt()}%',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.darkCard,
            borderRadius: radius,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: clampedProgress),
                duration: duration,
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: constraints.maxWidth * value,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            foregroundColor ?? AppColors.primary,
                            (foregroundColor ?? AppColors.primary).withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: radius,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Pulse animation for drawing attention
class PulseWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool animate;

  const PulseWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.minScale = 0.95,
    this.maxScale = 1.0,
    this.animate = true,
  });

  @override
  State<PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<PulseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.animate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Bounce animation for tap feedback
class BounceWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;

  const BounceWidget({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<BounceWidget> createState() => _BounceWidgetState();
}

class _BounceWidgetState extends State<BounceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse().then((_) {
        widget.onTap?.call();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Slide-in animation for list items
class SlideInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset beginOffset;
  final Curve curve;

  const SlideInWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.beginOffset = const Offset(0, 0.2),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<SlideInWidget> createState() => _SlideInWidgetState();
}

class _SlideInWidgetState extends State<SlideInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
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
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Staggered list animation helper
class StaggeredList extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDuration;
  final Duration staggerDelay;
  final Axis direction;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const StaggeredList({
    super.key,
    required this.children,
    this.itemDuration = const Duration(milliseconds: 400),
    this.staggerDelay = const Duration(milliseconds: 100),
    this.direction = Axis.vertical,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final animatedChildren = children.asMap().entries.map((entry) {
      return SlideInWidget(
        duration: itemDuration,
        delay: staggerDelay * entry.key,
        child: entry.value,
      );
    }).toList();

    if (direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: animatedChildren,
      );
    }
    
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: animatedChildren,
    );
  }
}

/// Confetti burst for achievements
class ConfettiWidget extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final VoidCallback? onComplete;

  const ConfettiWidget({
    super.key,
    required this.child,
    required this.trigger,
    this.onComplete,
  });

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(ConfettiWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !_hasTriggered) {
      _hasTriggered = true;
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (widget.trigger)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ConfettiPainter(
                      progress: _controller.value,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;

  _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0 || progress == 1) return;

    final particles = <_Particle>[
      _Particle(0.2, 0.1, AppColors.primary),
      _Particle(0.4, 0.15, AppColors.accent),
      _Particle(0.6, 0.12, AppColors.success),
      _Particle(0.8, 0.08, AppColors.gold),
      _Particle(0.3, 0.18, AppColors.error),
      _Particle(0.5, 0.1, AppColors.dusk400),
      _Particle(0.7, 0.14, AppColors.info),
    ];

    for (final particle in particles) {
      final x = size.width * particle.startX;
      final y = size.height * (1 - progress * (1 + particle.speed));
      final opacity = (1 - progress).clamp(0.0, 1.0);
      
      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _Particle {
  final double startX;
  final double speed;
  final Color color;

  _Particle(this.startX, this.speed, this.color);
}

/// Shake animation for errors/warnings
class ShakeWidget extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final Duration duration;
  final double offset;

  const ShakeWidget({
    super.key,
    required this.child,
    required this.trigger,
    this.duration = const Duration(milliseconds: 400),
    this.offset = 10,
  });

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );
  }

  @override
  void didUpdateWidget(ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !_hasTriggered) {
      _hasTriggered = true;
      _controller.forward(from: 0).then((_) {
        _hasTriggered = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getShakeOffset(double value) {
    return (-1 + 2 * (value * 4 - (value * 4).floor())) * widget.offset * (1 - value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_getShakeOffset(_animation.value), 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}


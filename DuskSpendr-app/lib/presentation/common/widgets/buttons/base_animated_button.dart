import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/spacing.dart';
import 'button_types.dart';

/// A base animated button that handles scale animation, gestures, and standard layout.
class BaseAnimatedButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? width;
  final ButtonSize size;

  // Style builders
  final BoxDecoration Function(bool isPressed, bool isDisabled)
  decorationBuilder;
  final Color Function(bool isDisabled) textColorBuilder;
  final Color? loaderColor;

  // Optional configuration
  final bool
  useWidth; // If true, uses width or double.infinity. If false, wraps content (like GhostButton).
  final double? heightOverride;
  final double? fontSizeOverride;
  final EdgeInsetsGeometry? paddingOverride;
  final Duration animationDuration;

  const BaseAnimatedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
    this.size = ButtonSize.medium,
    required this.decorationBuilder,
    required this.textColorBuilder,
    this.loaderColor,
    this.useWidth = true,
    this.heightOverride,
    this.fontSizeOverride,
    this.paddingOverride,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<BaseAnimatedButton> createState() => _BaseAnimatedButtonState();
}

class _BaseAnimatedButtonState extends State<BaseAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _height {
    if (widget.heightOverride != null) return widget.heightOverride!;
    switch (widget.size) {
      case ButtonSize.small:
        return 40;
      case ButtonSize.medium:
        return 52;
      case ButtonSize.large:
        return 60;
    }
  }

  double get _fontSize {
    if (widget.fontSizeOverride != null) return widget.fontSizeOverride!;
    switch (widget.size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled || widget.isLoading) return;
    setState(() => _isPressed = true);
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    _controller.reverse();
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = !widget.isEnabled || widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnimation.value, child: child),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: isDisabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: widget.animationDuration,
          width: widget.useWidth ? (widget.width ?? double.infinity) : null,
          height: _height,
          padding: widget.paddingOverride,
          decoration: widget.decorationBuilder(_isPressed, isDisabled),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.loaderColor ??
                            widget
                                .textColorBuilder(isDisabled)
                                .withValues(alpha: 0.9),
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: widget.textColorBuilder(isDisabled),
                          size: _fontSize + 4,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: _fontSize,
                          fontWeight: FontWeight.w600,
                          color: widget.textColorBuilder(isDisabled),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

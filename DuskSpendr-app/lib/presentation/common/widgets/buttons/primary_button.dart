import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import 'base_animated_button.dart';
import 'button_types.dart';

export 'button_types.dart';

/// A primary gradient button with loading state and haptic feedback.
/// Used for main CTAs throughout the app.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? width;
  final ButtonSize size;
  final bool isFullWidth;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
    this.size = ButtonSize.medium,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return BaseAnimatedButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      icon: icon,
      width: width,
      size: size,
      useWidth: true,
      textColorBuilder: (isDisabled) =>
          isDisabled ? AppColors.textMuted : AppColors.textPrimary,
      decorationBuilder: (isPressed, isDisabled) => BoxDecoration(
        gradient: isDisabled
            ? LinearGradient(
                colors: [
                  AppColors.dusk700.withValues(alpha: 0.5),
                  AppColors.dusk600.withValues(alpha: 0.5),
                ],
              )
            : AppColors.gradientDusk,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: isDisabled || isPressed
            ? null
            : [
                BoxShadow(
                  color: AppColors.dusk500.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      loaderColor: AppColors.textPrimary.withValues(alpha: 0.9),
    );
  }
}

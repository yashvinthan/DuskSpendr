import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import 'base_animated_button.dart';
import 'button_types.dart';

export 'button_types.dart';

/// Secondary outlined button for alternative actions.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? width;
  final ButtonSize size;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
    this.size = ButtonSize.medium,
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
          isDisabled ? AppColors.textMuted : AppColors.dusk500,
      decorationBuilder: (isPressed, isDisabled) => BoxDecoration(
        color: isPressed
            ? AppColors.dusk700.withValues(alpha: 0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDisabled
              ? AppColors.dusk700.withValues(alpha: 0.5)
              : AppColors.dusk500,
          width: 1.5,
        ),
      ),
      loaderColor: AppColors.dusk500.withValues(alpha: 0.9),
    );
  }
}

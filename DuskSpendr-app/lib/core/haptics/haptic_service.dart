import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// SS-195: Haptic Feedback Utility
/// Consistent haptic feedback patterns across the app

class HapticService {
  HapticService._();
  
  static bool _enabled = true;
  
  /// Enable or disable haptic feedback globally
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }
  
  /// Check if haptic feedback is enabled
  static bool get isEnabled => _enabled;

  // ============== Light Feedback ==============
  
  /// Light tap - for selections, toggles, small actions
  static Future<void> lightTap() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }

  /// Selection - when selecting items in a list
  static Future<void> selection() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  // ============== Medium Feedback ==============

  /// Medium tap - for confirmations, button presses
  static Future<void> mediumTap() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// Swipe action - when swiping to reveal actions
  static Future<void> swipe() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }

  // ============== Heavy Feedback ==============

  /// Heavy tap - for important actions, deletions
  static Future<void> heavyTap() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
  }

  /// Vibrate - strong feedback for alerts
  static Future<void> vibrate() async {
    if (!_enabled) return;
    await HapticFeedback.vibrate();
  }

  // ============== Semantic Feedback ==============

  /// Success - positive action completed
  static Future<void> success() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  /// Error - something went wrong
  static Future<void> error() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Warning - attention needed
  static Future<void> warning() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// Achievement unlocked - celebratory feedback
  static Future<void> achievement() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.lightImpact();
  }

  /// Transaction added
  static Future<void> transactionAdded() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// Transaction deleted
  static Future<void> transactionDeleted() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
  }

  /// Budget threshold warning
  static Future<void> budgetWarning() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.mediumImpact();
  }

  /// Pull to refresh triggered
  static Future<void> pullRefresh() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }

  /// Slider/picker value changed
  static Future<void> tick() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }
}

/// Extension to add haptic feedback to any widget
extension HapticWidgetExtension on Widget {
  Widget withHaptic(Future<void> Function() haptic) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => haptic(),
          child: this,
        );
      },
    );
  }
}

/// Wrapper widget that adds haptic feedback to tap events
class HapticFeedbackWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onTap;
  final HapticType type;

  const HapticFeedbackWrapper({
    super.key,
    required this.child,
    required this.onTap,
    this.type = HapticType.light,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _performHaptic();
        await onTap();
      },
      child: child,
    );
  }

  Future<void> _performHaptic() async {
    switch (type) {
      case HapticType.light:
        await HapticService.lightTap();
      case HapticType.medium:
        await HapticService.mediumTap();
      case HapticType.heavy:
        await HapticService.heavyTap();
      case HapticType.selection:
        await HapticService.selection();
      case HapticType.success:
        await HapticService.success();
      case HapticType.error:
        await HapticService.error();
    }
  }
}

enum HapticType {
  light,
  medium,
  heavy,
  selection,
  success,
  error,
}

/// Mixin to add haptic feedback to StatelessWidget or StatefulWidget
mixin HapticMixin {
  Future<void> hapticLight() => HapticService.lightTap();
  Future<void> hapticMedium() => HapticService.mediumTap();
  Future<void> hapticHeavy() => HapticService.heavyTap();
  Future<void> hapticSelection() => HapticService.selection();
  Future<void> hapticSuccess() => HapticService.success();
  Future<void> hapticError() => HapticService.error();
  Future<void> hapticWarning() => HapticService.warning();
}

/// Button with built-in haptic feedback
class HapticButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final HapticType hapticType;
  final ButtonStyle? style;

  const HapticButton({
    super.key,
    required this.child,
    this.onPressed,
    this.hapticType = HapticType.light,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: onPressed != null
          ? () async {
              await _performHaptic();
              onPressed!();
            }
          : null,
      child: child,
    );
  }

  Future<void> _performHaptic() async {
    switch (hapticType) {
      case HapticType.light:
        await HapticService.lightTap();
      case HapticType.medium:
        await HapticService.mediumTap();
      case HapticType.heavy:
        await HapticService.heavyTap();
      case HapticType.selection:
        await HapticService.selection();
      case HapticType.success:
        await HapticService.success();
      case HapticType.error:
        await HapticService.error();
    }
  }
}

/// IconButton with built-in haptic feedback
class HapticIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onPressed;
  final HapticType hapticType;
  final String? tooltip;
  final Color? color;

  const HapticIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.hapticType = HapticType.selection,
    this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      tooltip: tooltip,
      color: color,
      onPressed: onPressed != null
          ? () async {
              await _performHaptic();
              onPressed!();
            }
          : null,
    );
  }

  Future<void> _performHaptic() async {
    switch (hapticType) {
      case HapticType.light:
        await HapticService.lightTap();
      case HapticType.medium:
        await HapticService.mediumTap();
      case HapticType.heavy:
        await HapticService.heavyTap();
      case HapticType.selection:
        await HapticService.selection();
      case HapticType.success:
        await HapticService.success();
      case HapticType.error:
        await HapticService.error();
    }
  }
}

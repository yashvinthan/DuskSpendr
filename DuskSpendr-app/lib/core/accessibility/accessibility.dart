import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// SS-191: Accessibility utilities for WCAG 2.1 AA compliance
/// Provides semantic wrappers and accessibility helpers

/// Accessible wrapper that adds proper semantics to any widget
class AccessibleWidget extends StatelessWidget {
  final Widget child;
  final String label;
  final String? hint;
  final String? value;
  final bool? button;
  final bool? header;
  final bool? link;
  final bool? image;
  final bool? liveRegion;
  final bool excludeSemantics;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AccessibleWidget({
    super.key,
    required this.child,
    required this.label,
    this.hint,
    this.value,
    this.button,
    this.header,
    this.link,
    this.image,
    this.liveRegion,
    this.excludeSemantics = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: button,
      header: header,
      link: link,
      image: image,
      liveRegion: liveRegion ?? false,
      excludeSemantics: excludeSemantics,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}

/// Accessible button with minimum touch target size (48x48dp)
class AccessibleButton extends StatelessWidget {
  final Widget child;
  final String label;
  final String? hint;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final double minSize;
  final bool enableHaptic;

  const AccessibleButton({
    super.key,
    required this.child,
    required this.label,
    this.hint,
    this.onPressed,
    this.onLongPress,
    this.minSize = 48.0,
    this.enableHaptic = true,
  });

  void _handleTap() {
    if (enableHaptic) HapticFeedback.lightImpact();
    onPressed?.call();
  }

  void _handleLongPress() {
    if (enableHaptic) HapticFeedback.mediumImpact();
    onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      hint: hint,
      onTap: onPressed != null ? _handleTap : null,
      onLongPress: onLongPress != null ? _handleLongPress : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minSize,
          minHeight: minSize,
        ),
        child: GestureDetector(
          onTap: onPressed != null ? _handleTap : null,
          onLongPress: onLongPress != null ? _handleLongPress : null,
          behavior: HitTestBehavior.opaque,
          child: child,
        ),
      ),
    );
  }
}

/// Accessible transaction item with complete screen reader support
class AccessibleTransaction extends StatelessWidget {
  final Widget child;
  final String merchantName;
  final double amount;
  final bool isExpense;
  final String category;
  final DateTime date;
  final VoidCallback? onTap;

  const AccessibleTransaction({
    super.key,
    required this.child,
    required this.merchantName,
    required this.amount,
    required this.isExpense,
    required this.category,
    required this.date,
    this.onTap,
  });

  String get _accessibilityLabel {
    final action = isExpense ? 'Spent' : 'Received';
    final amountStr = '${amount.toStringAsFixed(0)} rupees';
    final dateStr = _formatDateForAccessibility(date);
    return '$action $amountStr at $merchantName, $category category, $dateStr';
  }

  String _formatDateForAccessibility(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: _accessibilityLabel,
      hint: onTap != null ? 'Double tap to view details' : null,
      onTap: onTap,
      child: child,
    );
  }
}

/// Accessible amount display with currency announcement
class AccessibleAmount extends StatelessWidget {
  final Widget child;
  final double amount;
  final String currency;
  final bool isExpense;
  final bool liveRegion;

  const AccessibleAmount({
    super.key,
    required this.child,
    required this.amount,
    this.currency = 'rupees',
    this.isExpense = true,
    this.liveRegion = false,
  });

  String get _label {
    final sign = isExpense ? 'minus' : 'plus';
    return '$sign ${amount.toStringAsFixed(0)} $currency';
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _label,
      liveRegion: liveRegion,
      child: ExcludeSemantics(child: child),
    );
  }
}

/// Accessible progress indicator (for budgets, goals)
class AccessibleProgress extends StatelessWidget {
  final Widget child;
  final String label;
  final double value;
  final double max;
  final String? unit;

  const AccessibleProgress({
    super.key,
    required this.child,
    required this.label,
    required this.value,
    required this.max,
    this.unit,
  });

  String get _accessibilityLabel {
    final percentage = ((value / max) * 100).toStringAsFixed(0);
    final unitStr = unit != null ? ' $unit' : '';
    return '$label: ${value.toStringAsFixed(0)}$unitStr of ${max.toStringAsFixed(0)}$unitStr, $percentage percent';
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _accessibilityLabel,
      value: '${(value / max * 100).toStringAsFixed(0)}%',
      child: ExcludeSemantics(child: child),
    );
  }
}

/// Live region for announcing dynamic updates
class LiveRegion extends StatelessWidget {
  final Widget child;
  final String announcement;
  final bool polite;

  const LiveRegion({
    super.key,
    required this.child,
    required this.announcement,
    this.polite = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: announcement,
      child: child,
    );
  }
}

/// Accessibility helper methods
class A11y {
  A11y._();

  /// Check if reduce motion is enabled
  static bool reduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Check if bold text is enabled
  static bool boldText(BuildContext context) {
    return MediaQuery.of(context).boldText;
  }

  /// Check if high contrast is enabled
  static bool highContrast(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  /// Get accessible text scale factor (clamped)
  static double textScaleFactor(BuildContext context, {double max = 1.5}) {
    return MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, max);
  }

  /// Calculate WCAG contrast ratio between two colors
  static double contrastRatio(Color foreground, Color background) {
    final l1 = _relativeLuminance(foreground);
    final l2 = _relativeLuminance(background);
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 < l2 ? l1 : l2;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if contrast ratio meets WCAG AA (4.5:1 for normal text)
  static bool meetsContrastAA(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= 4.5;
  }

  /// Check if contrast ratio meets WCAG AAA (7:1 for normal text)
  static bool meetsContrastAAA(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= 7.0;
  }

  static double _relativeLuminance(Color color) {
    double channel(double value) {
      return value <= 0.03928
          ? value / 12.92
          : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
    }
    return 0.2126 * channel(color.r) +
           0.7152 * channel(color.g) +
           0.0722 * channel(color.b);
  }

  /// Announce to screen reader
  static void announce(BuildContext context, String message) {
    SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      Directionality.of(context),
    );
  }

  /// Focus node for accessibility navigation
  static FocusNode createFocusNode({String? debugLabel}) {
    return FocusNode(debugLabel: debugLabel);
  }
}

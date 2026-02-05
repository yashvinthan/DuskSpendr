import 'package:flutter/material.dart';

/// Spec 6: Typography scale (SS-080)
class AppTypography {
  // Display styles
  static const displayLarge = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
  );

  static const displayMedium = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
  );

  // Heading styles (Spec 6)
  static const h1 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 28, // Spec: 28sp
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -0.5,
  );

  static const h2 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 24, // Spec: 24sp
    fontWeight: FontWeight.w600, // SemiBold
  );

  static const h3 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 20, // Spec: 20sp
    fontWeight: FontWeight.w500, // Medium
  );

  // Body styles (Spec 6)
  static const bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16, // Spec: 16sp
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
  );

  static const bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14, // Spec: 14sp
    fontWeight: FontWeight.w400, // Regular
    height: 1.4,
  );

  static const bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Caption (Spec 6)
  static const caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12, // Spec: 12sp
    fontWeight: FontWeight.w400, // Regular
    height: 1.3,
  );

  // Amount display (monospace for numbers)
  static const amount = TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const amountLarge = TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
  );

  static const amountSmall = TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Button text
  static const button = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Chip/Tag labels
  static const label = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  // Score display
  static const score = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 56,
    fontWeight: FontWeight.w800,
    letterSpacing: -2,
  );

  // Material 3 compatible aliases
  static const headlineSmall = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const titleLarge = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const titleMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  static const titleSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // Material 3 display variants
  static const displaySmall = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  // Material 3 headline variants
  static const headlineMedium = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  // Material 3 label variants
  static const labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const labelMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const labelSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}

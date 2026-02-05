import 'package:flutter/material.dart';

/// Spec 6: Student-friendly color palette
class AppColors {
  // Primary palette (Spec 6)
  static const primary = Color(0xFF6C5CE7); // Actions, focus elements
  static const accent = Color(0xFF00B894);  // Success, positive amounts
  static const warning = Color(0xFFFDCB6E); // Alerts, approaching limits
  static const danger = Color(0xFFE17055);  // Over budget, debits

  // Legacy dusk palette (still used for gradients)
  static const dusk900 = Color(0xFF1A0A2E);
  static const dusk800 = Color(0xFF2D1B4E);
  static const dusk700 = Color(0xFF432874);
  static const dusk600 = Color(0xFF5C3D9A);
  static const dusk500 = Color(0xFF6C5CE7); // Aligned with primary

  static const sunset500 = Color(0xFFF97316);
  static const sunset400 = Color(0xFFFB923C);
  static const sunset300 = Color(0xFFFDBA74);
  static const gold500 = Color(0xFFEAB308);
  static const gold400 = Color(0xFFFACC15);

  // Gradients
  static const gradientDusk = LinearGradient(
    colors: [dusk500, sunset500, gold400],
  );
  static const gradientNight = LinearGradient(
    colors: [dusk900, dusk700, dusk600],
  );
  static const gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFF8E7CF3)],
  );

  // Light mode backgrounds (Spec 6)
  static const lightBackground = Color(0xFFF5F6FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);

  // Dark mode backgrounds (Spec 6)
  static const darkBackground = Color(0xFF1E272E);
  static const darkSurface = Color(0xFF2D3436);
  static const darkCard = Color(0xFF3D4449);

  // OLED-friendly true black
  static const oledBackground = Color(0xFF000000);
  static const oledSurface = Color(0xFF0A0A0A);
  static const oledCard = Color(0xFF121212);

  // Text colors - Light mode
  static const textPrimaryLight = Color(0xFF2D3436);
  static const textSecondaryLight = Color(0xFF636E72);
  static const textMutedLight = Color(0xFFB2BEC3);

  // Text colors - Dark mode
  static const textPrimary = Color(0xFFFAFAFA);
  static const textSecondary = Color(0xFFA1A1AA);
  static const textMuted = Color(0xFF71717A);

  // Semantic colors
  static const success = Color(0xFF00B894);
  static const error = Color(0xFFE17055);
  static const info = Color(0xFF0984E3);
  
  // Category colors (student-friendly)
  static const categoryFood = Color(0xFFFF7675);
  static const categoryTransport = Color(0xFF74B9FF);
  static const categoryEntertainment = Color(0xFFFDCB6E);
  static const categoryEducation = Color(0xFF81ECEC);
  static const categoryShopping = Color(0xFFE84393);
  static const categoryBills = Color(0xFF6C5CE7);
  static const categorySavings = Color(0xFF00B894);
  static const categoryHealth = Color(0xFF00CEC9);
  static const categoryOther = Color(0xFFB2BEC3);

  // Finance Score level colors
  static const scoreBeginner = Color(0xFFE17055);
  static const scoreSaver = Color(0xFFFDCB6E);
  static const scoreSmartSpender = Color(0xFF74B9FF);
  static const scoreMoneyMaster = Color(0xFF00B894);
  static const scoreFinanceWizard = Color(0xFF6C5CE7);

  /// Get category color by category name
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food': return categoryFood;
      case 'transport': return categoryTransport;
      case 'entertainment': return categoryEntertainment;
      case 'education': return categoryEducation;
      case 'shopping': return categoryShopping;
      case 'bills': return categoryBills;
      case 'savings': return categorySavings;
      case 'health': return categoryHealth;
      default: return categoryOther;
    }
  }

  /// Get score level color
  static Color getScoreColor(int score) {
    if (score >= 81) return scoreFinanceWizard;
    if (score >= 61) return scoreMoneyMaster;
    if (score >= 41) return scoreSmartSpender;
    if (score >= 21) return scoreSaver;
    return scoreBeginner;
  }
}

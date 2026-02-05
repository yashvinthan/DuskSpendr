import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_theme.dart';

/// SS-089: Theme mode provider with persistence

enum AppThemeMode {
  system,
  light,
  dark,
  oled, // OLED-friendly true black
}

/// Theme mode state notifier
class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  static const _themeKey = 'app_theme_mode';

  ThemeModeNotifier() : super(AppThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    if (themeIndex < AppThemeMode.values.length) {
      state = AppThemeMode.values[themeIndex];
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  Future<void> toggleDarkMode() async {
    if (state == AppThemeMode.light) {
      await setThemeMode(AppThemeMode.dark);
    } else {
      await setThemeMode(AppThemeMode.light);
    }
  }
}

/// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, AppThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Resolved ThemeMode for MaterialApp
final resolvedThemeModeProvider = Provider<ThemeMode>((ref) {
  final appThemeMode = ref.watch(themeModeProvider);
  switch (appThemeMode) {
    case AppThemeMode.system:
      return ThemeMode.system;
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
    case AppThemeMode.oled:
      return ThemeMode.dark;
  }
});

/// Get the appropriate ThemeData
final lightThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.lightTheme;
});

final darkThemeProvider = Provider<ThemeData>((ref) {
  final appThemeMode = ref.watch(themeModeProvider);
  if (appThemeMode == AppThemeMode.oled) {
    return AppTheme.oledDarkTheme;
  }
  return AppTheme.darkTheme;
});

/// Is dark mode currently active
final isDarkModeProvider = Provider<bool>((ref) {
  final mode = ref.watch(themeModeProvider);
  return mode == AppThemeMode.dark || mode == AppThemeMode.oled;
});

/// Is OLED mode active
final isOledModeProvider = Provider<bool>((ref) {
  final mode = ref.watch(themeModeProvider);
  return mode == AppThemeMode.oled;
});

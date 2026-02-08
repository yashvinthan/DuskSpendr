import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/notifications/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/navigation/app_router.dart';
import 'providers/auth_providers.dart';
import 'providers/theme_provider.dart';
import 'providers/onboarding_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await NotificationService.instance.initialize();
  
  // Set system UI overlay style for dusk theme (default)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D0B1E),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Preload SharedPreferences for onboarding check
  final prefs = await SharedPreferences.getInstance();
  final hasCompletedOnboarding = prefs.getBool('has_completed_onboarding') ?? false;

  runApp(
    ProviderScope(
      overrides: [
        // Override with preloaded value
        onboardingStatusProvider.overrideWith((ref) => hasCompletedOnboarding),
      ],
      child: const DuskSpendrApp(),
    ),
  );
}

/// Router provider that watches auth and onboarding
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  final hasCompletedOnboarding = ref.watch(onboardingStatusProvider);

  return AppRouter.createRouter(
    isAuthenticated: authState.status == AuthStatus.authenticated,
    hasCompletedOnboarding: hasCompletedOnboarding,
  );
});

class DuskSpendrApp extends ConsumerWidget {
  const DuskSpendrApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(resolvedThemeModeProvider);
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);

    return MaterialApp.router(
      title: 'DuskSpendr',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}

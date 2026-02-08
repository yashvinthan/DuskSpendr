import 'package:flutter/foundation.dart';

/// Central app configuration. Production URLs must be set via --dart-define.
/// Never commit production API keys or secrets to the repo.
class AppConfig {
  AppConfig._();

  /// API base URL. In production must be HTTPS and set via:
  /// flutter run --dart-define=API_BASE_URL=https://api.yourdomain.com
  /// or in CI: --dart-define=API_BASE_URL=$API_BASE_URL
  static String get apiBaseUrl {
    const value = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: _defaultBaseUrl,
    );
    if (kReleaseMode && value.startsWith('http://')) {
      assert(
        false,
        'Production builds must use HTTPS for API_BASE_URL. '
        'Use --dart-define=API_BASE_URL=https://...',
      );
    }
    return value;
  }

  /// Default only for debug/profile. Never use http in release.
  static const String _defaultBaseUrl =
      'http://10.0.2.2:8080'; // Android emulator localhost

  /// Gateway URL. In production must be HTTPS and set via:
  /// flutter run --dart-define=GATEWAY_URL=https://gateway.yourdomain.com
  static String get gatewayUrl {
    const value = String.fromEnvironment(
      'GATEWAY_URL',
      defaultValue: _defaultGatewayUrl,
    );
    if (kReleaseMode && value.startsWith('http://')) {
      assert(
        false,
        'Production builds must use HTTPS for GATEWAY_URL. '
        'Use --dart-define=GATEWAY_URL=https://...',
      );
    }
    return value;
  }

  static const String _defaultGatewayUrl =
      'http://10.0.2.2:8000'; // Android emulator localhost

  static bool get isProduction => kReleaseMode;
  static bool get isDebug => kDebugMode;
}

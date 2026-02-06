import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'account_linker.dart';

/// SS-011: OAuth 2.0 Authentication
/// Authorization code flow with PKCE, token refresh, MFA handling
class OAuthService {
  /// Generate PKCE code verifier (43-128 chars)
  String generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(64, (i) => random.nextInt(256));
    return base64UrlEncode(values).replaceAll('=', '').substring(0, 64);
  }

  /// Generate PKCE code challenge from verifier
  String generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  /// Generate random state parameter
  String generateState() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64UrlEncode(values).replaceAll('=', '');
  }

  /// Build authorization URL with PKCE
  String buildAuthorizationUrl({
    required String baseUrl,
    required String clientId,
    required String redirectUri,
    required String scope,
    required String codeChallenge,
    required String state,
    Map<String, String>? additionalParams,
  }) {
    final params = {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'scope': scope,
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
      'state': state,
      ...?additionalParams,
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: params);
    return uri.toString();
  }

  /// Parse authorization callback URL
  AuthCallbackResult parseCallback(String callbackUrl) {
    final uri = Uri.parse(callbackUrl);
    final code = uri.queryParameters['code'];
    final state = uri.queryParameters['state'];
    final error = uri.queryParameters['error'];
    final errorDescription = uri.queryParameters['error_description'];

    if (error != null) {
      return AuthCallbackResult.failure(
        errorDescription ?? error,
        isCanceled: error == 'access_denied' || error == 'user_cancelled',
      );
    }

    if (code == null) {
      return AuthCallbackResult.failure('No authorization code received');
    }

    return AuthCallbackResult.success(code: code, state: state);
  }

  /// Validate state parameter
  bool validateState(String receivedState, String expectedState) {
    return receivedState == expectedState;
  }
}

class AuthCallbackResult {
  final bool success;
  final String? code;
  final String? state;
  final String? error;
  final bool isCanceled;

  const AuthCallbackResult({
    required this.success,
    this.code,
    this.state,
    this.error,
    this.isCanceled = false,
  });

  factory AuthCallbackResult.success({
    required String code,
    String? state,
  }) =>
      AuthCallbackResult(
        success: true,
        code: code,
        state: state,
      );

  factory AuthCallbackResult.failure(String error, {bool isCanceled = false}) =>
      AuthCallbackResult(
        success: false,
        error: error,
        isCanceled: isCanceled,
      );
}

/// OAuth configuration for providers
class OAuthConfig {
  final String clientId;
  final String clientSecret;
  final String authorizationEndpoint;
  final String tokenEndpoint;
  final String redirectUri;
  final List<String> scopes;
  final Map<String, String>? additionalParams;
  final bool enabled;

  const OAuthConfig({
    required this.clientId,
    required this.clientSecret,
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
    required this.redirectUri,
    required this.scopes,
    this.additionalParams,
    this.enabled = true,
  });

  String get scopeString => scopes.join(' ');

  bool get isValid =>
      enabled &&
      clientId.isNotEmpty &&
      authorizationEndpoint.isNotEmpty &&
      tokenEndpoint.isNotEmpty &&
      redirectUri.isNotEmpty;
}

/// OAuth configurations for each provider
class ProviderOAuthConfigs {
  static const _redirectScheme = String.fromEnvironment(
    'OAUTH_REDIRECT_SCHEME',
    defaultValue: 'duskspendr',
  );

  // Google Pay OAuth Config
  static OAuthConfig get gpay => const OAuthConfig(
        clientId: String.fromEnvironment('OAUTH_GPAY_CLIENT_ID'),
        clientSecret: String.fromEnvironment('OAUTH_GPAY_CLIENT_SECRET'),
        authorizationEndpoint: 'https://accounts.google.com/o/oauth2/v2/auth',
        tokenEndpoint: 'https://oauth2.googleapis.com/token',
        redirectUri: '$_redirectScheme://oauth/gpay/callback',
        scopes: [
          'https://www.googleapis.com/auth/payments.transactions.readonly',
        ],
        additionalParams: {
          'access_type': 'offline',
          'prompt': 'consent',
        },
        enabled: bool.fromEnvironment('FEATURE_GPAY', defaultValue: false),
      );

  // PhonePe OAuth Config (simulated - actual API may vary)
  static OAuthConfig get phonepe => const OAuthConfig(
        clientId: String.fromEnvironment('OAUTH_PHONEPE_CLIENT_ID'),
        clientSecret: String.fromEnvironment('OAUTH_PHONEPE_CLIENT_SECRET'),
        authorizationEndpoint: 'https://api.phonepe.com/apps/oauth/authorize',
        tokenEndpoint: 'https://api.phonepe.com/apps/oauth/token',
        redirectUri: '$_redirectScheme://oauth/phonepe/callback',
        scopes: ['transactions.read', 'balance.read'],
        enabled: bool.fromEnvironment('FEATURE_PHONEPE', defaultValue: false),
      );

  // Paytm OAuth Config
  static OAuthConfig get paytm => const OAuthConfig(
        clientId: String.fromEnvironment('OAUTH_PAYTM_CLIENT_ID'),
        clientSecret: String.fromEnvironment('OAUTH_PAYTM_CLIENT_SECRET'),
        authorizationEndpoint: 'https://accounts.paytm.com/oauth2/authorize',
        tokenEndpoint: 'https://accounts.paytm.com/oauth2/token',
        redirectUri: '$_redirectScheme://oauth/paytm/callback',
        scopes: ['wallet', 'transaction_history'],
        enabled: bool.fromEnvironment('FEATURE_PAYTM_UPI', defaultValue: false),
      );

  // Zerodha Kite Connect Config
  static OAuthConfig get zerodha => const OAuthConfig(
        clientId: String.fromEnvironment('OAUTH_ZERODHA_CLIENT_ID'),
        clientSecret: String.fromEnvironment('OAUTH_ZERODHA_CLIENT_SECRET'),
        authorizationEndpoint: 'https://kite.zerodha.com/connect/login',
        tokenEndpoint: 'https://api.kite.trade/session/token',
        redirectUri: '$_redirectScheme://oauth/zerodha/callback',
        scopes: ['holdings', 'orders', 'positions'],
        enabled: bool.fromEnvironment('FEATURE_ZERODHA', defaultValue: false),
      );

  // Groww OAuth Config (simulated)
  static OAuthConfig get groww => const OAuthConfig(
        clientId: String.fromEnvironment('OAUTH_GROWW_CLIENT_ID'),
        clientSecret: String.fromEnvironment('OAUTH_GROWW_CLIENT_SECRET'),
        authorizationEndpoint: 'https://groww.in/oauth/authorize',
        tokenEndpoint: 'https://api.groww.in/oauth/token',
        redirectUri: '$_redirectScheme://oauth/groww/callback',
        scopes: ['portfolio.read', 'transactions.read'],
        enabled: bool.fromEnvironment('FEATURE_GROWW', defaultValue: false),
      );

  // Upstox OAuth Config
  static OAuthConfig get upstox => const OAuthConfig(
        clientId: String.fromEnvironment('OAUTH_UPSTOX_CLIENT_ID'),
        clientSecret: String.fromEnvironment('OAUTH_UPSTOX_CLIENT_SECRET'),
        authorizationEndpoint: 'https://api.upstox.com/v2/login/authorization/dialog',
        tokenEndpoint: 'https://api.upstox.com/v2/login/authorization/token',
        redirectUri: '$_redirectScheme://oauth/upstox/callback',
        scopes: ['portfolio', 'orders'],
        enabled: bool.fromEnvironment('FEATURE_UPSTOX', defaultValue: false),
      );

  // Angel One SmartAPI Config
  static OAuthConfig get angelOne => const OAuthConfig(
        clientId: String.fromEnvironment('OAUTH_ANGEL_ONE_CLIENT_ID'),
        clientSecret: String.fromEnvironment('OAUTH_ANGEL_ONE_CLIENT_SECRET'),
        authorizationEndpoint: 'https://smartapi.angelbroking.com/rest/auth/angelbroking/user/v1/loginByPassword',
        tokenEndpoint: 'https://smartapi.angelbroking.com/rest/auth/angelbroking/jwt/v1/generateTokens',
        redirectUri: '$_redirectScheme://oauth/angelone/callback',
        scopes: ['portfolio', 'orders', 'holdings'],
        enabled: bool.fromEnvironment('FEATURE_ANGEL_ONE', defaultValue: false),
      );

  static OAuthConfig? getConfig(AccountProviderType provider) {
    switch (provider) {
      case AccountProviderType.gpay:
        return gpay;
      case AccountProviderType.phonepe:
        return phonepe;
      case AccountProviderType.paytmUpi:
      case AccountProviderType.paytmWallet:
        return paytm;
      case AccountProviderType.zerodha:
      case AccountProviderType.zerodhaCoins:
        return zerodha;
      case AccountProviderType.groww:
        return groww;
      case AccountProviderType.upstox:
        return upstox;
      case AccountProviderType.angelOne:
        return angelOne;
      default:
        return null;
    }
  }
}

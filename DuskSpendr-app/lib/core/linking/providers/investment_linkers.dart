import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import '../account_linker.dart';
import '../oauth_service.dart';

/// SS-026 to SS-031: Investment Platform Integrations
/// Zerodha, Groww, Upstox, Angel One, Coin by Zerodha, INDmoney

/// Base class for investment platform linkers
abstract class InvestmentLinker implements AccountLinker {
  @override
  bool get supportsRealTimeSync => false; // Investment data updates less frequently
}

/// SS-026: Zerodha Kite Integration
class ZerodhaLinker extends InvestmentLinker {
  final http.Client _httpClient;
  final OAuthService _oauthService;

  ZerodhaLinker({http.Client? httpClient, OAuthService? oauthService})
      : _httpClient = httpClient ?? http.Client(),
        _oauthService = oauthService ?? OAuthService();

  @override
  AccountProviderType get providerType => AccountProviderType.zerodha;

  @override
  String get displayName => 'Zerodha Kite';

  @override
  String get iconPath => 'assets/icons/providers/zerodha.png';

  final _apiKey = const String.fromEnvironment('OAUTH_ZERODHA_CLIENT_ID');
  final _baseUrl = 'https://api.kite.trade';

  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    if (_apiKey.isEmpty) {
      return AuthorizationResult.failure('Provider not configured');
    }
    final state = _oauthService.generateState();
    final authUrl = 'https://kite.zerodha.com/connect/login?'
        'v=3&api_key=$_apiKey&redirect_params=state:$state';

    return AuthorizationResult.success(
      authorizationUrl: authUrl,
      state: state,
    );
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    if (_apiKey.isEmpty) {
      return TokenResult.failure('Provider not configured');
    }
    try {
      // Exchange token via backend to keep secret secure
      final backendUrl = '${AppConfig.apiBaseUrl}/api/v1/investments/zerodha/exchange';

      final response = await _httpClient.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // The backend proxies the Zerodha response directly
        // { "status": "success", "data": { ... } }
        if (data['status'] == 'success') {
          return TokenResult.success(
            accessToken: data['data']['access_token'],
            metadata: {
              'user_id': data['data']['user_id'],
              'user_name': data['data']['user_name'],
            },
          );
        }
      }
      return TokenResult.failure('Token exchange failed');
    } catch (e) {
      return TokenResult.failure('Token exchange error: $e');
    }
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    // Kite tokens are valid for one day and need re-login
    return TokenResult.failure('Kite requires daily re-authorization');
  }

  @override
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    if (_apiKey.isEmpty) {
      return TransactionFetchResult.failure('Provider not configured');
    }
    try {
      // Fetch orders (trades) history
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/orders'),
        headers: {
          'Authorization': 'token $_apiKey:$accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final orders = (data['data'] as List? ?? []);
        final transactions = orders
            .where((o) => o['status'] == 'COMPLETE')
            .map((o) => ProviderTransaction(
                  providerId: o['order_id'] ?? '',
                  amountPaisa: ((o['average_price'] ?? 0) * (o['filled_quantity'] ?? 0) * 100).round(),
                  isDebit: o['transaction_type'] == 'BUY',
                  timestamp: DateTime.parse(o['order_timestamp'] ?? DateTime.now().toIso8601String()),
                  merchantName: o['tradingsymbol'],
                  description: '${o['transaction_type']} ${o['filled_quantity']} ${o['tradingsymbol']}',
                  rawData: o,
                ))
            .toList();

        return TransactionFetchResult.success(transactions: transactions);
      }
      return TransactionFetchResult.failure('Failed to fetch orders');
    } catch (e) {
      return TransactionFetchResult.failure('Fetch error: $e');
    }
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    if (_apiKey.isEmpty) {
      return BalanceResult.failure('Provider not configured');
    }
    try {
      // Fetch holdings value
      final holdingsResponse = await _httpClient.get(
        Uri.parse('$_baseUrl/portfolio/holdings'),
        headers: {'Authorization': 'token $_apiKey:$accessToken'},
      );

      if (holdingsResponse.statusCode == 200) {
        final data = jsonDecode(holdingsResponse.body);
        final holdings = data['data'] as List? ?? [];
        
        int totalValuePaisa = 0;
        for (final holding in holdings) {
          final quantity = (holding['quantity'] as num?) ?? 0;
          final lastPrice = (holding['last_price'] as num?) ?? 0;
          totalValuePaisa += (quantity * lastPrice * 100).round();
        }

        return BalanceResult.success(balancePaisa: totalValuePaisa);
      }
      return BalanceResult.failure('Failed to fetch holdings');
    } catch (e) {
      return BalanceResult.failure('Holdings error: $e');
    }
  }

  @override
  Future<bool> revokeAccess(String accessToken) async {
    if (_apiKey.isEmpty) {
      return false;
    }
    try {
      await _httpClient.delete(
        Uri.parse('$_baseUrl/session/token'),
        headers: {'Authorization': 'token $_apiKey:$accessToken'},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  LinkingError handleError(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('TokenException')) {
      return LinkingError.tokenExpired();
    }
    return LinkingError.unknown(errorStr);
  }
}

/// SS-027: Groww Integration
class GrowwLinker extends InvestmentLinker {
  final http.Client _httpClient;

  GrowwLinker({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  @override
  AccountProviderType get providerType => AccountProviderType.groww;

  @override
  String get displayName => 'Groww';

  @override
  String get iconPath => 'assets/icons/providers/groww.png';

  final _baseUrl = 'https://api.groww.in/v1';

  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    final config = ProviderOAuthConfigs.groww;
    if (!config.isValid) {
      return AuthorizationResult.failure('Provider not configured');
    }
    return AuthorizationResult.success(
      authorizationUrl: '${config.authorizationEndpoint}?'
          'client_id=${config.clientId}'
          '&redirect_uri=${config.redirectUri}'
          '&scope=${config.scopeString}'
          '&response_type=code',
    );
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    // OAuth flow implementation
    return TokenResult.failure('Not implemented');
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    return TokenResult.failure('Not implemented');
  }

  @override
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    try {
      // Fetch stocks and MF transactions
      final stocksResponse = await _httpClient.get(
        Uri.parse('$_baseUrl/stocks/orders'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      final mfResponse = await _httpClient.get(
        Uri.parse('$_baseUrl/mutual-funds/transactions'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      final transactions = <ProviderTransaction>[];

      if (stocksResponse.statusCode == 200) {
        final data = jsonDecode(stocksResponse.body);
        for (final order in (data['orders'] as List? ?? [])) {
          transactions.add(ProviderTransaction(
            providerId: order['orderId'] ?? '',
            amountPaisa: ((order['value'] ?? 0) * 100).round(),
            isDebit: order['action'] == 'BUY',
            timestamp: DateTime.parse(order['timestamp'] ?? DateTime.now().toIso8601String()),
            merchantName: order['symbol'],
            description: '${order['action']} ${order['quantity']} ${order['symbol']}',
            rawData: order,
          ));
        }
      }

      if (mfResponse.statusCode == 200) {
        final data = jsonDecode(mfResponse.body);
        for (final tx in (data['transactions'] as List? ?? [])) {
          transactions.add(ProviderTransaction(
            providerId: tx['transactionId'] ?? '',
            amountPaisa: ((tx['amount'] ?? 0) * 100).round(),
            isDebit: tx['type'] == 'PURCHASE',
            timestamp: DateTime.parse(tx['date'] ?? DateTime.now().toIso8601String()),
            merchantName: tx['schemeName'],
            description: '${tx['type']} ${tx['schemeName']}',
            rawData: tx,
          ));
        }
      }

      return TransactionFetchResult.success(transactions: transactions);
    } catch (e) {
      return TransactionFetchResult.failure('Fetch error: $e');
    }
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    try {
      final holdingsResponse = await _httpClient.get(
        Uri.parse('$_baseUrl/portfolio/summary'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (holdingsResponse.statusCode == 200) {
        final data = jsonDecode(holdingsResponse.body);
        final totalValue = (data['totalValue'] ?? 0) * 100;
        return BalanceResult.success(balancePaisa: totalValue.round());
      }
      return BalanceResult.failure('Failed to fetch portfolio');
    } catch (e) {
      return BalanceResult.failure('Portfolio error: $e');
    }
  }

  @override
  Future<bool> revokeAccess(String accessToken) async => true;

  @override
  LinkingError handleError(dynamic error) => LinkingError.unknown(error.toString());
}

/// SS-028: Upstox Integration
class UpstoxLinker extends InvestmentLinker {
  final http.Client _httpClient;
  final OAuthService _oauthService;

  UpstoxLinker({http.Client? httpClient, OAuthService? oauthService})
      : _httpClient = httpClient ?? http.Client(),
        _oauthService = oauthService ?? OAuthService();

  @override
  AccountProviderType get providerType => AccountProviderType.upstox;

  @override
  String get displayName => 'Upstox';

  @override
  String get iconPath => 'assets/icons/providers/upstox.png';

  final _baseUrl = 'https://api.upstox.com/v2';

  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    final config = ProviderOAuthConfigs.upstox;
    final state = _oauthService.generateState();
    if (!config.isValid) {
      return AuthorizationResult.failure('Provider not configured');
    }

    return AuthorizationResult.success(
      authorizationUrl: '${config.authorizationEndpoint}?'
          'client_id=${config.clientId}'
          '&redirect_uri=${config.redirectUri}'
          '&response_type=code'
          '&state=$state',
      state: state,
    );
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    final config = ProviderOAuthConfigs.upstox;
    if (!config.isValid) {
      return TokenResult.failure('Provider not configured');
    }
    try {
      final response = await _httpClient.post(
        Uri.parse(config.tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'code': code,
          'client_id': config.clientId,
          'client_secret': config.clientSecret,
          'redirect_uri': config.redirectUri,
          'grant_type': 'authorization_code',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TokenResult.success(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          expiresAt: DateTime.now().add(Duration(seconds: data['expires_in'] ?? 86400)),
        );
      }
      return TokenResult.failure('Token exchange failed');
    } catch (e) {
      return TokenResult.failure('Token exchange error: $e');
    }
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    return TokenResult.failure('Upstox requires daily re-authorization');
  }

  @override
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/order/history'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final orders = (data['data'] as List? ?? []);
        final transactions = orders
            .map((o) => ProviderTransaction(
                  providerId: o['order_id'] ?? '',
                  amountPaisa: ((o['price'] ?? 0) * (o['quantity'] ?? 0) * 100).round(),
                  isDebit: o['transaction_type'] == 'BUY',
                  timestamp: DateTime.parse(o['order_timestamp'] ?? DateTime.now().toIso8601String()),
                  merchantName: o['tradingsymbol'],
                  description: '${o['transaction_type']} ${o['quantity']} ${o['tradingsymbol']}',
                  rawData: o,
                ))
            .toList();

        return TransactionFetchResult.success(transactions: transactions);
      }
      return TransactionFetchResult.failure('Failed to fetch orders');
    } catch (e) {
      return TransactionFetchResult.failure('Fetch error: $e');
    }
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/portfolio/holdings'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final holdings = data['data'] as List? ?? [];

        int totalValuePaisa = 0;
        for (final h in holdings) {
          final lastPrice = (h['last_price'] as num?) ?? 0;
          final quantity = (h['quantity'] as num?) ?? 0;
          totalValuePaisa += (lastPrice * quantity * 100).round();
        }

        return BalanceResult.success(balancePaisa: totalValuePaisa);
      }
      return BalanceResult.failure('Failed to fetch holdings');
    } catch (e) {
      return BalanceResult.failure('Holdings error: $e');
    }
  }

  @override
  Future<bool> revokeAccess(String accessToken) async {
    try {
      await _httpClient.delete(
        Uri.parse('$_baseUrl/login/token'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  LinkingError handleError(dynamic error) => LinkingError.unknown(error.toString());
}

/// SS-029: Angel One Integration
class AngelOneLinker extends InvestmentLinker {
  static const _angelApiKey = String.fromEnvironment('OAUTH_ANGEL_ONE_CLIENT_ID');
  @override
  AccountProviderType get providerType => AccountProviderType.angelOne;

  @override
  String get displayName => 'Angel One';

  @override
  String get iconPath => 'assets/icons/providers/angel_one.png';

  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    if (!const bool.fromEnvironment('FEATURE_ANGEL_ONE', defaultValue: false) ||
        _angelApiKey.isEmpty) {
      return AuthorizationResult.failure('Provider not configured');
    }
    return AuthorizationResult.success(
      authorizationUrl:
          'https://smartapi.angelbroking.com/publisher-login?api_key=$_angelApiKey',
    );
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    return TokenResult.failure('Not implemented');
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    return TokenResult.failure('Not implemented');
  }

  @override
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    return TransactionFetchResult.failure('Not implemented');
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    return BalanceResult.failure('Not implemented');
  }

  @override
  Future<bool> revokeAccess(String accessToken) async => true;

  @override
  LinkingError handleError(dynamic error) => LinkingError.unknown(error.toString());
}

/// SS-030: Coin by Zerodha (Mutual Funds)
class ZerodhaCoinsLinker extends InvestmentLinker {
  @override
  AccountProviderType get providerType => AccountProviderType.zerodhaCoins;

  @override
  String get displayName => 'Coin by Zerodha';

  @override
  String get iconPath => 'assets/icons/providers/coin_zerodha.png';

  // Uses same auth as Zerodha Kite
  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    return ZerodhaLinker().initiateAuthorization();
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    return ZerodhaLinker().exchangeAuthorizationCode(code, verifier);
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    return TokenResult.failure('Requires daily re-authorization');
  }

  @override
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    // Fetch MF orders from Kite API
    return TransactionFetchResult.failure('Not implemented');
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    // Fetch MF holdings value
    return BalanceResult.failure('Not implemented');
  }

  @override
  Future<bool> revokeAccess(String accessToken) async => true;

  @override
  LinkingError handleError(dynamic error) => LinkingError.unknown(error.toString());
}

/// SS-031: INDmoney Integration
class IndmoneyLinker extends InvestmentLinker {
  @override
  AccountProviderType get providerType => AccountProviderType.indmoney;

  @override
  String get displayName => 'INDmoney';

  @override
  String get iconPath => 'assets/icons/providers/indmoney.png';

  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    if (!const bool.fromEnvironment('FEATURE_INDMONEY', defaultValue: false)) {
      return AuthorizationResult.failure('Provider not configured');
    }
    return AuthorizationResult.success(
      authorizationUrl: 'https://indmoney.com/connect?app=duskspendr',
    );
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    return TokenResult.failure('Not implemented');
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    return TokenResult.failure('Not implemented');
  }

  @override
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    return TransactionFetchResult.failure('Not implemented');
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    return BalanceResult.failure('Not implemented');
  }

  @override
  Future<bool> revokeAccess(String accessToken) async => true;

  @override
  LinkingError handleError(dynamic error) => LinkingError.unknown(error.toString());
}

/// Factory for creating investment linkers
class InvestmentLinkerFactory {
  static AccountLinker? create(AccountProviderType type) {
    switch (type) {
      case AccountProviderType.zerodha:
        return ZerodhaLinker();
      case AccountProviderType.groww:
        return GrowwLinker();
      case AccountProviderType.upstox:
        return UpstoxLinker();
      case AccountProviderType.angelOne:
        return AngelOneLinker();
      case AccountProviderType.zerodhaCoins:
        return ZerodhaCoinsLinker();
      case AccountProviderType.indmoney:
        return IndmoneyLinker();
      default:
        return null;
    }
  }

  static List<AccountLinker> getAllInvestmentLinkers() => [
        ZerodhaLinker(),
        GrowwLinker(),
        UpstoxLinker(),
        AngelOneLinker(),
        ZerodhaCoinsLinker(),
        IndmoneyLinker(),
      ];
}

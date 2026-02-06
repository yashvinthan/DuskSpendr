import 'dart:convert';
import 'package:http/http.dart' as http;

import '../account_linker.dart';
import '../oauth_service.dart';

/// SS-019 to SS-023: Wallet & BNPL Integrations
/// Amazon Pay, Paytm Wallet, LazyPay, Simpl, Amazon Pay Later

/// SS-019: Amazon Pay Wallet
class AmazonPayLinker implements AccountLinker {
  final http.Client _httpClient;
  final OAuthService _oauthService;

  AmazonPayLinker({http.Client? httpClient, OAuthService? oauthService})
      : _httpClient = httpClient ?? http.Client(),
        _oauthService = oauthService ?? OAuthService();

  @override
  AccountProviderType get providerType => AccountProviderType.amazonPay;

  @override
  String get displayName => 'Amazon Pay';

  @override
  String get iconPath => 'assets/icons/providers/amazon_pay.png';

  @override
  bool get supportsRealTimeSync => false;

  final _baseUrl = 'https://api.amazon.in/pay/v1';
  static const _amazonClientId = String.fromEnvironment('OAUTH_AMAZON_CLIENT_ID');
  static const _amazonRedirectUri = String.fromEnvironment(
    'OAUTH_AMAZON_REDIRECT_URI',
    defaultValue: 'duskspendr://oauth/amazon/callback',
  );

  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    if (_amazonClientId.isEmpty) {
      return AuthorizationResult.failure('Provider not configured');
    }
    try {
      final verifier = _oauthService.generateCodeVerifier();
      final challenge = _oauthService.generateCodeChallenge(verifier);
      final state = _oauthService.generateState();

      final authUrl = 'https://www.amazon.in/ap/oa?'
          'client_id=$_amazonClientId'
          '&scope=payments:wallet_balance%20payments:transactions'
          '&response_type=code'
          '&redirect_uri=$_amazonRedirectUri'
          '&state=$state'
          '&code_challenge=$challenge'
          '&code_challenge_method=S256';

      return AuthorizationResult.success(
        authorizationUrl: authUrl,
        codeVerifier: verifier,
        state: state,
      );
    } catch (e) {
      return AuthorizationResult.failure('Failed to initiate Amazon OAuth: $e');
    }
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    if (_amazonClientId.isEmpty) {
      return TokenResult.failure('Provider not configured');
    }
    try {
      final response = await _httpClient.post(
        Uri.parse('https://api.amazon.in/auth/o2/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': _amazonRedirectUri,
          'client_id': _amazonClientId,
          if (verifier != null) 'code_verifier': verifier,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TokenResult.success(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          expiresAt: DateTime.now().add(Duration(seconds: data['expires_in'] ?? 3600)),
        );
      }
      return TokenResult.failure('Token exchange failed');
    } catch (e) {
      return TokenResult.failure('Token exchange error: $e');
    }
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    if (_amazonClientId.isEmpty) {
      return TokenResult.failure('Provider not configured');
    }
    try {
      final response = await _httpClient.post(
        Uri.parse('https://api.amazon.in/auth/o2/token'),
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': _amazonClientId,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TokenResult.success(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'] ?? refreshToken,
          expiresAt: DateTime.now().add(Duration(seconds: data['expires_in'] ?? 3600)),
        );
      }
      return TokenResult.failure('Token refresh failed');
    } catch (e) {
      return TokenResult.failure('Token refresh error: $e');
    }
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
        Uri.parse('$_baseUrl/wallet/transactions'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final transactions = (data['transactions'] as List? ?? [])
            .map((tx) => ProviderTransaction(
                  providerId: tx['transactionId'] ?? '',
                  amountPaisa: ((tx['amount'] ?? 0) * 100).round(),
                  isDebit: tx['type'] == 'DEBIT',
                  timestamp: DateTime.parse(tx['date'] ?? DateTime.now().toIso8601String()),
                  merchantName: tx['merchant'],
                  description: tx['description'],
                  rawData: tx,
                ))
            .toList();

        return TransactionFetchResult.success(transactions: transactions);
      }
      return TransactionFetchResult.failure('Failed to fetch transactions');
    } catch (e) {
      return TransactionFetchResult.failure('Fetch error: $e');
    }
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/wallet/balance'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BalanceResult.success(
          balancePaisa: ((data['balance'] ?? 0) * 100).round(),
        );
      }
      return BalanceResult.failure('Failed to fetch balance');
    } catch (e) {
      return BalanceResult.failure('Balance error: $e');
    }
  }

  @override
  Future<bool> revokeAccess(String accessToken) async {
    try {
      await _httpClient.post(
        Uri.parse('https://api.amazon.in/auth/o2/revoke'),
        body: {'token': accessToken},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  LinkingError handleError(dynamic error) {
    return LinkingError.unknown(error.toString());
  }
}

/// SS-020: Paytm Wallet
class PaytmWalletLinker implements AccountLinker {
  final http.Client _httpClient;
  final OAuthService _oauthService;

  PaytmWalletLinker({
    http.Client? httpClient,
    OAuthService? oauthService,
  })  : _httpClient = httpClient ?? http.Client(),
        _oauthService = oauthService ?? OAuthService();

  @override
  AccountProviderType get providerType => AccountProviderType.paytmWallet;

  @override
  String get displayName => 'Paytm Wallet';

  @override
  String get iconPath => 'assets/icons/providers/paytm_wallet.png';

  @override
  bool get supportsRealTimeSync => false;

  final _baseUrl = 'https://accounts.paytm.com/api/v1';

  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    final config = ProviderOAuthConfigs.paytm;
    if (!config.isValid) {
      return AuthorizationResult.failure('Provider not configured');
    }
    final state = _oauthService.generateState();
    final verifier = _oauthService.generateCodeVerifier();
    final challenge = _oauthService.generateCodeChallenge(verifier);
    return AuthorizationResult.success(
      authorizationUrl: '${config.authorizationEndpoint}?'
          'client_id=${config.clientId}'
          '&redirect_uri=${config.redirectUri}'
          '&scope=wallet%20balance%20transaction_history'
          '&response_type=code'
          '&state=$state'
          '&code_challenge=$challenge'
          '&code_challenge_method=S256',
      state: state,
      codeVerifier: verifier,
    );
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    final config = ProviderOAuthConfigs.paytm;
    if (!config.isValid) {
      return TokenResult.failure('Provider not configured');
    }
    try {
      final body = <String, String>{
        'grant_type': 'authorization_code',
        'code': code,
        'client_id': config.clientId,
        'redirect_uri': config.redirectUri,
        if (config.clientSecret.isNotEmpty) 'client_secret': config.clientSecret,
        if (verifier != null) 'code_verifier': verifier,
      };
      final response = await _httpClient.post(
        Uri.parse(config.tokenEndpoint),
        headers: <String, String>{'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return TokenResult.success(
          accessToken: data['access_token'] as String,
          refreshToken: data['refresh_token'] as String?,
          expiresAt: DateTime.now().add(
            Duration(seconds: (data['expires_in'] as num?)?.toInt() ?? 3600),
          ),
        );
      }
      return TokenResult.failure(
        'Token exchange failed: ${response.statusCode}',
      );
    } catch (e) {
      return TokenResult.failure('Token exchange error: $e');
    }
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    final config = ProviderOAuthConfigs.paytm;
    if (!config.isValid) {
      return TokenResult.failure('Provider not configured');
    }
    try {
      final body = <String, String>{
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': config.clientId,
        if (config.clientSecret.isNotEmpty) 'client_secret': config.clientSecret,
      };
      final response = await _httpClient.post(
        Uri.parse(config.tokenEndpoint),
        headers: <String, String>{'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return TokenResult.success(
          accessToken: data['access_token'] as String,
          refreshToken: data['refresh_token'] as String? ?? refreshToken,
          expiresAt: DateTime.now().add(
            Duration(seconds: (data['expires_in'] as num?)?.toInt() ?? 3600),
          ),
        );
      }
      return TokenResult.failure('Token refresh failed');
    } catch (e) {
      return TokenResult.failure('Token refresh error: $e');
    }
  }

  @override
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/wallet/passbook'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': 'WALLET',
          if (from != null) 'fromDate': from.toIso8601String(),
          if (to != null) 'toDate': to.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final transactions = (data['body']?['walletTxns'] as List? ?? [])
            .map((tx) => ProviderTransaction(
                  providerId: tx['txnId'] ?? '',
                  amountPaisa: ((tx['amount'] ?? 0) * 100).round(),
                  isDebit: tx['txnType'] == 'DEBIT',
                  timestamp: DateTime.parse(tx['txnDate'] ?? DateTime.now().toIso8601String()),
                  merchantName: tx['merchantName'],
                  description: tx['comments'],
                  rawData: tx,
                ))
            .toList();

        return TransactionFetchResult.success(transactions: transactions);
      }
      return TransactionFetchResult.failure('Failed to fetch wallet transactions');
    } catch (e) {
      return TransactionFetchResult.failure('Fetch error: $e');
    }
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/wallet/balance'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BalanceResult.success(
          balancePaisa: ((data['body']?['totalBalance'] ?? 0) * 100).round(),
        );
      }
      return BalanceResult.failure('Failed to fetch balance');
    } catch (e) {
      return BalanceResult.failure('Balance error: $e');
    }
  }

  @override
  Future<bool> revokeAccess(String accessToken) async => true;

  @override
  LinkingError handleError(dynamic error) => LinkingError.unknown(error.toString());
}

/// SS-021: LazyPay BNPL
class LazypayLinker implements AccountLinker {
  final http.Client _httpClient;

  LazypayLinker({http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();

  @override
  AccountProviderType get providerType => AccountProviderType.lazypay;

  @override
  String get displayName => 'LazyPay';

  @override
  String get iconPath => 'assets/icons/providers/lazypay.png';

  @override
  bool get supportsRealTimeSync => false;

  final _baseUrl = 'https://api.lazypay.in/v1';

  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    return AuthorizationResult.success(
      authorizationUrl: 'https://lazypay.in/link?app=duskspendr',
    );
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    return TokenResult.failure('Use deep link callback');
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    return TokenResult.failure('Not supported');
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
        Uri.parse('$_baseUrl/transactions'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final transactions = (data['transactions'] as List? ?? [])
            .map((tx) => ProviderTransaction(
                  providerId: tx['id'] ?? '',
                  amountPaisa: ((tx['amount'] ?? 0) * 100).round(),
                  isDebit: true, // BNPL is always spending
                  timestamp: DateTime.parse(tx['created_at'] ?? DateTime.now().toIso8601String()),
                  merchantName: tx['merchant'],
                  description: tx['description'],
                  rawData: tx,
                ))
            .toList();

        return TransactionFetchResult.success(transactions: transactions);
      }
      return TransactionFetchResult.failure('Failed to fetch transactions');
    } catch (e) {
      return TransactionFetchResult.failure('Fetch error: $e');
    }
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/credit'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Return outstanding dues as negative balance
        final outstanding = ((data['outstanding'] ?? 0) * 100).round();
        return BalanceResult.success(balancePaisa: -outstanding);
      }
      return BalanceResult.failure('Failed to fetch credit info');
    } catch (e) {
      return BalanceResult.failure('Credit info error: $e');
    }
  }

  @override
  Future<bool> revokeAccess(String accessToken) async => true;

  @override
  LinkingError handleError(dynamic error) => LinkingError.unknown(error.toString());
}

/// SS-022: Simpl BNPL
class SimplLinker implements AccountLinker {
  final http.Client _httpClient;

  SimplLinker({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  AccountProviderType get providerType => AccountProviderType.simpl;

  @override
  String get displayName => 'Simpl';

  @override
  String get iconPath => 'assets/icons/providers/simpl.png';

  @override
  bool get supportsRealTimeSync => false;

  static const _baseUrl = 'https://api.getsimpl.com/v1';

  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    return AuthorizationResult.success(
      authorizationUrl: 'https://getsimpl.com/link?app=duskspendr',
    );
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    return TokenResult.failure('Use deep link callback');
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    return TokenResult.failure('Not supported');
  }

  @override
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    try {
      final queryParams = <String, String>{
        if (from != null) 'from': from.toIso8601String(),
        if (to != null) 'to': to.toIso8601String(),
        if (cursor != null) 'cursor': cursor,
        'limit': '100',
      };
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/transactions').replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['transactions'] as List? ?? [];
        final transactions = list
            .map((tx) => ProviderTransaction(
                  providerId: tx['id']?.toString() ?? '',
                  amountPaisa: ((tx['amount'] ?? 0) * 100).round(),
                  isDebit: tx['type'] != 'CREDIT',
                  timestamp: DateTime.parse(
                      tx['created_at'] ?? DateTime.now().toIso8601String()),
                  merchantName: tx['merchant_name']?.toString(),
                  description: tx['description']?.toString(),
                  rawData: tx as Map<String, dynamic>,
                ))
            .toList();

        return TransactionFetchResult.success(
          transactions: transactions,
          nextCursor: data['next_cursor'],
          hasMore: data['has_more'] ?? false,
        );
      }
      return TransactionFetchResult.failure('Failed to fetch Simpl transactions');
    } catch (e) {
      return TransactionFetchResult.failure('Simpl fetch error: $e');
    }
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/credit/outstanding'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final outstanding = ((data['outstanding'] ?? 0) * 100).round();
        return BalanceResult.success(balancePaisa: -outstanding);
      }
      return BalanceResult.failure('Failed to fetch Simpl credit info');
    } catch (e) {
      return BalanceResult.failure('Simpl balance error: $e');
    }
  }

  @override
  Future<bool> revokeAccess(String accessToken) async => true;

  @override
  LinkingError handleError(dynamic error) => LinkingError.unknown(error.toString());
}

/// SS-023: Amazon Pay Later
class AmazonPayLaterLinker implements AccountLinker {
  final http.Client _httpClient;

  AmazonPayLaterLinker({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _amazonClientId = String.fromEnvironment('OAUTH_AMAZON_CLIENT_ID');
  static const _amazonRedirectUri = String.fromEnvironment(
    'OAUTH_AMAZON_REDIRECT_URI',
    defaultValue: 'duskspendr://oauth/amazon/callback',
  );
  @override
  AccountProviderType get providerType => AccountProviderType.amazonPayLater;

  @override
  String get displayName => 'Amazon Pay Later';

  @override
  String get iconPath => 'assets/icons/providers/amazon_pay_later.png';

  @override
  bool get supportsRealTimeSync => false;

  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    if (_amazonClientId.isEmpty) {
      return AuthorizationResult.failure('Provider not configured');
    }
    // Uses same auth as Amazon Pay
    return AuthorizationResult.success(
      authorizationUrl: 'https://www.amazon.in/ap/oa?'
          'client_id=$_amazonClientId'
          '&scope=pay_later:transactions'
          '&response_type=code'
          '&redirect_uri=$_amazonRedirectUri',
    );
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    return TokenResult.failure('Use Amazon Pay auth');
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    return TokenResult.failure('Use Amazon Pay auth');
  }

  @override
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    if (_amazonClientId.isEmpty) {
      return TransactionFetchResult.failure('Provider not configured');
    }
    try {
      final response = await _httpClient.get(
        Uri.parse('https://api.amazon.in/pay/v1/pay_later/transactions'),
        headers: <String, String>{'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['transactions'] as List? ?? [];
        final transactions = list
            .map((tx) => ProviderTransaction(
                  providerId: tx['transactionId'] ?? '',
                  amountPaisa: ((tx['amount'] ?? 0) * 100).round(),
                  isDebit: tx['type'] == 'DEBIT',
                  timestamp: DateTime.parse(
                      tx['date'] ?? DateTime.now().toIso8601String()),
                  merchantName: tx['merchant'],
                  description: tx['description'],
                  rawData: tx as Map<String, dynamic>,
                ))
            .toList();

        return TransactionFetchResult.success(transactions: transactions);
      }
      return TransactionFetchResult.failure('Failed to fetch Pay Later transactions');
    } catch (e) {
      return TransactionFetchResult.failure('Pay Later fetch error: $e');
    }
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    if (_amazonClientId.isEmpty) {
      return BalanceResult.failure('Provider not configured');
    }
    try {
      final response = await _httpClient.get(
        Uri.parse('https://api.amazon.in/pay/v1/pay_later/limit'),
        headers: <String, String>{'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final limit = ((data['creditLimit'] ?? 0) * 100).round();
        final used = ((data['usedLimit'] ?? 0) * 100).round();
        return BalanceResult.success(balancePaisa: limit - used);
      }
      return BalanceResult.failure('Failed to fetch Pay Later limit');
    } catch (e) {
      return BalanceResult.failure('Pay Later balance error: $e');
    }
  }

  @override
  Future<bool> revokeAccess(String accessToken) async => true;

  @override
  LinkingError handleError(dynamic error) => LinkingError.unknown(error.toString());
}

/// Factory for creating wallet/BNPL linkers
class WalletBnplLinkerFactory {
  static AccountLinker? create(AccountProviderType type) {
    switch (type) {
      case AccountProviderType.amazonPay:
        return AmazonPayLinker();
      case AccountProviderType.paytmWallet:
        return PaytmWalletLinker();
      case AccountProviderType.lazypay:
        return LazypayLinker();
      case AccountProviderType.simpl:
        return SimplLinker();
      case AccountProviderType.amazonPayLater:
        return AmazonPayLaterLinker();
      default:
        return null;
    }
  }

  static List<AccountLinker> getAllWalletLinkers() => [
        AmazonPayLinker(),
        PaytmWalletLinker(),
      ];

  static List<AccountLinker> getAllBnplLinkers() => [
        LazypayLinker(),
        SimplLinker(),
        AmazonPayLaterLinker(),
      ];
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../account_linker.dart';
import '../oauth_service.dart';

/// SS-016 to SS-018: UPI App Integrations
/// Google Pay, PhonePe, Paytm UPI integrations

/// Base class for UPI app linkers
abstract class UpiLinker implements AccountLinker {
  final OAuthService _oauthService;
  final http.Client _httpClient;
  
  @override
  bool get supportsRealTimeSync => true; // UPI apps support real-time notifications

  UpiLinker({
    OAuthService? oauthService,
    http.Client? httpClient,
  })  : _oauthService = oauthService ?? OAuthService(),
        _httpClient = httpClient ?? http.Client();

  /// OAuth configuration
  OAuthConfig get oauthConfig;

  /// API base URL for transactions
  String get apiBaseUrl;

  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    if (!oauthConfig.isValid) {
      return AuthorizationResult.failure('Provider not configured');
    }
    try {
      final verifier = _oauthService.generateCodeVerifier();
      final challenge = _oauthService.generateCodeChallenge(verifier);
      final state = _oauthService.generateState();

      final authUrl = _oauthService.buildAuthorizationUrl(
        baseUrl: oauthConfig.authorizationEndpoint,
        clientId: oauthConfig.clientId,
        redirectUri: oauthConfig.redirectUri,
        scope: oauthConfig.scopeString,
        codeChallenge: challenge,
        state: state,
        additionalParams: oauthConfig.additionalParams,
      );

      return AuthorizationResult.success(
        authorizationUrl: authUrl,
        codeVerifier: verifier,
        state: state,
      );
    } catch (e) {
      return AuthorizationResult.failure('Failed to initiate OAuth: $e');
    }
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    if (!oauthConfig.isValid) {
      return TokenResult.failure('Provider not configured');
    }
    try {
      final response = await _httpClient.post(
        Uri.parse(oauthConfig.tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'client_id': oauthConfig.clientId,
          'redirect_uri': oauthConfig.redirectUri,
          if (verifier != null) 'code_verifier': verifier,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TokenResult.success(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          expiresAt: DateTime.now().add(Duration(seconds: data['expires_in'] ?? 3600)),
          metadata: {
            'token_type': data['token_type'],
            'scope': data['scope'],
          },
        );
      }
      return TokenResult.failure('Token exchange failed: ${response.statusCode}');
    } catch (e) {
      return TokenResult.failure('Token exchange error: $e');
    }
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    if (!oauthConfig.isValid) {
      return TokenResult.failure('Provider not configured');
    }
    try {
      final response = await _httpClient.post(
        Uri.parse(oauthConfig.tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': oauthConfig.clientId,
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
  Future<bool> revokeAccess(String accessToken) async {
    if (!oauthConfig.isValid) {
      return false;
    }
    try {
      // Most OAuth providers have a revoke endpoint
      await _httpClient.post(
        Uri.parse('${oauthConfig.tokenEndpoint.replaceAll('/token', '/revoke')}'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $accessToken',
        },
        body: {'token': accessToken},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  LinkingError handleError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('network') || errorStr.contains('socket')) {
      return LinkingError.network(error.toString());
    }
    if (errorStr.contains('401') || errorStr.contains('unauthorized')) {
      return LinkingError.tokenExpired();
    }
    if (errorStr.contains('429') || errorStr.contains('rate')) {
      return LinkingError.rateLimited();
    }
    if (errorStr.contains('cancel') || errorStr.contains('denied')) {
      return LinkingError.canceled();
    }
    return LinkingError.unknown(error.toString());
  }
}

/// SS-016: Google Pay Integration
class GpayLinker extends UpiLinker {
  @override
  AccountProviderType get providerType => AccountProviderType.gpay;

  @override
  String get displayName => 'Google Pay';

  @override
  String get iconPath => 'assets/icons/providers/gpay.png';

  @override
  OAuthConfig get oauthConfig => ProviderOAuthConfigs.gpay;

  @override
  String get apiBaseUrl => 'https://payments.googleapis.com/v1';

  @override
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    try {
      final queryParams = {
        if (from != null) 'startTime': from.toIso8601String(),
        if (to != null) 'endTime': to.toIso8601String(),
        if (cursor != null) 'pageToken': cursor,
        'maxResults': '100',
      };

      final response = await http.get(
        Uri.parse('$apiBaseUrl/transactions').replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final transactions = (data['transactions'] as List? ?? [])
            .map((tx) => _mapGpayTransaction(tx))
            .toList();

        return TransactionFetchResult.success(
          transactions: transactions,
          nextCursor: data['nextPageToken'],
          hasMore: data['nextPageToken'] != null,
        );
      }
      return TransactionFetchResult.failure('Failed to fetch GPay transactions');
    } catch (e) {
      return TransactionFetchResult.failure('GPay fetch error: $e');
    }
  }

  ProviderTransaction _mapGpayTransaction(Map<String, dynamic> tx) {
    final amount = tx['transactionAmount'] as Map<String, dynamic>?;
    final amountPaisa = ((amount?['value'] ?? 0) * 100).round();
    
    return ProviderTransaction(
      providerId: tx['transactionId'] ?? '',
      amountPaisa: amountPaisa,
      isDebit: tx['transactionType'] == 'PAYMENT',
      timestamp: DateTime.parse(tx['transactionTime'] ?? DateTime.now().toIso8601String()),
      merchantName: tx['merchantName'],
      description: tx['description'],
      referenceId: tx['upiTransactionId'],
      upiId: tx['receiverUpiId'],
      rawData: tx,
    );
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    // GPay doesn't expose wallet balance directly
    return BalanceResult.failure('Balance not available for Google Pay');
  }
}

/// SS-017: PhonePe Integration
class PhonepeLinker extends UpiLinker {
  @override
  AccountProviderType get providerType => AccountProviderType.phonepe;

  @override
  String get displayName => 'PhonePe';

  @override
  String get iconPath => 'assets/icons/providers/phonepe.png';

  @override
  OAuthConfig get oauthConfig => ProviderOAuthConfigs.phonepe;

  @override
  String get apiBaseUrl => 'https://api.phonepe.com/apps/v1';

  @override
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    try {
      final queryParams = {
        if (from != null) 'fromDate': from.millisecondsSinceEpoch.toString(),
        if (to != null) 'toDate': to.millisecondsSinceEpoch.toString(),
        if (cursor != null) 'offset': cursor,
        'limit': '100',
      };

      final response = await http.get(
        Uri.parse('$apiBaseUrl/transactions').replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'X-APP-ID': oauthConfig.clientId,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final txList = data['data']?['transactions'] as List? ?? [];
        final transactions = txList.map((tx) => _mapPhonepeTransaction(tx)).toList();

        return TransactionFetchResult.success(
          transactions: transactions,
          nextCursor: data['data']?['nextOffset']?.toString(),
          hasMore: data['data']?['hasMore'] ?? false,
        );
      }
      return TransactionFetchResult.failure('Failed to fetch PhonePe transactions');
    } catch (e) {
      return TransactionFetchResult.failure('PhonePe fetch error: $e');
    }
  }

  ProviderTransaction _mapPhonepeTransaction(Map<String, dynamic> tx) {
    return ProviderTransaction(
      providerId: tx['transactionId'] ?? '',
      amountPaisa: tx['amount'] ?? 0,
      isDebit: tx['type'] == 'DEBIT',
      timestamp: DateTime.fromMillisecondsSinceEpoch(tx['timestamp'] ?? 0),
      merchantName: tx['merchantName'],
      description: tx['remarks'],
      referenceId: tx['upiTxnId'],
      upiId: tx['payeeVpa'],
      rawData: tx,
    );
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/wallet/balance'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'X-APP-ID': oauthConfig.clientId,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BalanceResult.success(
          balancePaisa: data['data']?['balance'] ?? 0,
        );
      }
      return BalanceResult.failure('Failed to fetch PhonePe balance');
    } catch (e) {
      return BalanceResult.failure('PhonePe balance error: $e');
    }
  }
}

/// SS-018: Paytm UPI Integration
class PaytmUpiLinker extends UpiLinker {
  @override
  AccountProviderType get providerType => AccountProviderType.paytmUpi;

  @override
  String get displayName => 'Paytm UPI';

  @override
  String get iconPath => 'assets/icons/providers/paytm.png';

  @override
  OAuthConfig get oauthConfig => ProviderOAuthConfigs.paytm;

  @override
  String get apiBaseUrl => 'https://accounts.paytm.com/api/v1';

  @override
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    try {
      final body = {
        'type': 'UPI',
        if (from != null) 'fromDate': from.toIso8601String(),
        if (to != null) 'toDate': to.toIso8601String(),
        if (cursor != null) 'pageToken': cursor,
        'pageSize': 100,
      };

      final response = await http.post(
        Uri.parse('$apiBaseUrl/transactions/list'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final txList = data['body']?['transactions'] as List? ?? [];
        final transactions = txList.map((tx) => _mapPaytmTransaction(tx)).toList();

        return TransactionFetchResult.success(
          transactions: transactions,
          nextCursor: data['body']?['nextPageToken'],
          hasMore: data['body']?['hasMore'] ?? false,
        );
      }
      return TransactionFetchResult.failure('Failed to fetch Paytm transactions');
    } catch (e) {
      return TransactionFetchResult.failure('Paytm fetch error: $e');
    }
  }

  ProviderTransaction _mapPaytmTransaction(Map<String, dynamic> tx) {
    return ProviderTransaction(
      providerId: tx['orderId'] ?? '',
      amountPaisa: ((tx['txnAmount'] ?? 0) * 100).round(),
      isDebit: tx['txnType'] == 'DEBIT',
      timestamp: DateTime.parse(tx['txnDate'] ?? DateTime.now().toIso8601String()),
      merchantName: tx['merchantName'],
      description: tx['orderInfo'],
      referenceId: tx['upiRefNo'],
      upiId: tx['payerVpa'] ?? tx['payeeVpa'],
      rawData: tx,
    );
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    // UPI doesn't have wallet balance
    return BalanceResult.failure('Balance not available for UPI');
  }
}

/// Factory for creating UPI linkers
class UpiLinkerFactory {
  static AccountLinker? create(AccountProviderType type) {
    switch (type) {
      case AccountProviderType.gpay:
        return GpayLinker();
      case AccountProviderType.phonepe:
        return PhonepeLinker();
      case AccountProviderType.paytmUpi:
        return PaytmUpiLinker();
      default:
        return null;
    }
  }

  static List<AccountLinker> getAllUpiLinkers() => [
        GpayLinker(),
        PhonepeLinker(),
        PaytmUpiLinker(),
      ];
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../account_linker.dart';
import '../oauth_service.dart';

/// SS-012 to SS-015: Bank Linking Implementations
/// SBI, HDFC, ICICI, Axis bank integrations via Account Aggregator framework

/// Base class for bank linkers using Account Aggregator (AA) framework
abstract class BankLinker implements AccountLinker {
  final OAuthService _oauthService;
  final http.Client _httpClient;
  
  BankLinker({
    OAuthService? oauthService,
    http.Client? httpClient,
  })  : _oauthService = oauthService ?? OAuthService(),
        _httpClient = httpClient ?? http.Client();

  /// Account Aggregator base URL
  String get aaBaseUrl;

  /// Bank-specific FIP ID
  String get fipId;

  @override
  bool get supportsRealTimeSync => false; // Banks sync periodically

  @override
  Future<AuthorizationResult> initiateAuthorization() async {
    if (aaBaseUrl.isEmpty || fipId.isEmpty) {
      return AuthorizationResult.failure('Provider not configured');
    }
    try {
      final verifier = _oauthService.generateCodeVerifier();
      final challenge = _oauthService.generateCodeChallenge(verifier);
      final state = _oauthService.generateState();

      // Build AA consent request
      final consentUrl = '$aaBaseUrl/consent/request?'
          'fipId=$fipId'
          '&purpose=expense_tracking'
          '&state=$state'
          '&code_challenge=$challenge'
          '&code_challenge_method=S256';

      return AuthorizationResult.success(
        authorizationUrl: consentUrl,
        codeVerifier: verifier,
        state: state,
      );
    } catch (e) {
      return AuthorizationResult.failure('Failed to initiate authorization: $e');
    }
  }

  @override
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier) async {
    if (aaBaseUrl.isEmpty || fipId.isEmpty) {
      return TokenResult.failure('Provider not configured');
    }
    try {
      final response = await _httpClient.post(
        Uri.parse('$aaBaseUrl/consent/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': code,
          'code_verifier': verifier,
          'fip_id': fipId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TokenResult.success(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          expiresAt: DateTime.now().add(Duration(seconds: data['expires_in'] ?? 3600)),
          metadata: {'consent_id': data['consent_id']},
        );
      }
      return TokenResult.failure('Token exchange failed: ${response.statusCode}');
    } catch (e) {
      return TokenResult.failure('Token exchange error: $e');
    }
  }

  @override
  Future<TokenResult> refreshAccessToken(String refreshToken) async {
    if (aaBaseUrl.isEmpty) {
      return TokenResult.failure('Provider not configured');
    }
    try {
      final response = await _httpClient.post(
        Uri.parse('$aaBaseUrl/consent/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
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
    if (aaBaseUrl.isEmpty) {
      return TransactionFetchResult.failure('Provider not configured');
    }
    try {
      final queryParams = {
        if (from != null) 'from': from.toIso8601String(),
        if (to != null) 'to': to.toIso8601String(),
        if (cursor != null) 'cursor': cursor,
        'limit': '100',
      };

      final response = await _httpClient.get(
        Uri.parse('$aaBaseUrl/data/transactions').replace(queryParameters: queryParams),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final transactions = (data['transactions'] as List? ?? [])
            .map((tx) => _mapTransaction(tx))
            .toList();

        return TransactionFetchResult.success(
          transactions: transactions,
          nextCursor: data['next_cursor'],
          hasMore: data['has_more'] ?? false,
        );
      }
      return TransactionFetchResult.failure('Failed to fetch transactions');
    } catch (e) {
      return TransactionFetchResult.failure('Fetch error: $e');
    }
  }

  ProviderTransaction _mapTransaction(Map<String, dynamic> tx) {
    return ProviderTransaction(
      providerId: tx['txn_id'] ?? '',
      amountPaisa: ((tx['amount'] ?? 0) * 100).round(),
      isDebit: tx['type'] == 'DEBIT',
      timestamp: DateTime.parse(tx['timestamp'] ?? DateTime.now().toIso8601String()),
      merchantName: tx['narration']?.toString().split('/').first,
      description: tx['narration'],
      referenceId: tx['reference'],
      rawData: tx,
    );
  }

  @override
  Future<BalanceResult> fetchBalance(String accessToken) async {
    if (aaBaseUrl.isEmpty) {
      return BalanceResult.failure('Provider not configured');
    }
    try {
      final response = await _httpClient.get(
        Uri.parse('$aaBaseUrl/data/balance'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BalanceResult.success(
          balancePaisa: ((data['balance'] ?? 0) * 100).round(),
          updatedAt: DateTime.parse(data['as_of'] ?? DateTime.now().toIso8601String()),
          accountNumber: data['account_number'],
        );
      }
      return BalanceResult.failure('Failed to fetch balance');
    } catch (e) {
      return BalanceResult.failure('Balance fetch error: $e');
    }
  }

  @override
  Future<bool> revokeAccess(String accessToken) async {
    if (aaBaseUrl.isEmpty) {
      return false;
    }
    try {
      final response = await _httpClient.post(
        Uri.parse('$aaBaseUrl/consent/revoke'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  LinkingError handleError(dynamic error) {
    if (error.toString().contains('network') ||
        error.toString().contains('SocketException')) {
      return LinkingError.network(error.toString());
    }
    if (error.toString().contains('401') ||
        error.toString().contains('unauthorized')) {
      return LinkingError.tokenExpired();
    }
    if (error.toString().contains('429')) {
      return LinkingError.rateLimited();
    }
    return LinkingError.unknown(error.toString());
  }
}

/// SS-012: SBI Bank Linking
class SbiBankLinker extends BankLinker {
  static const _aaBaseUrl = String.fromEnvironment('AA_SBI_BASE_URL');
  static const _fipId = String.fromEnvironment('AA_SBI_FIP_ID');
  @override
  AccountProviderType get providerType => AccountProviderType.sbi;

  @override
  String get displayName => 'State Bank of India';

  @override
  String get iconPath => 'assets/icons/providers/sbi.png';

  @override
  String get aaBaseUrl => _aaBaseUrl;

  @override
  String get fipId => _fipId;
}

/// SS-013: HDFC Bank Linking
class HdfcBankLinker extends BankLinker {
  static const _aaBaseUrl = String.fromEnvironment('AA_HDFC_BASE_URL');
  static const _fipId = String.fromEnvironment('AA_HDFC_FIP_ID');
  @override
  AccountProviderType get providerType => AccountProviderType.hdfc;

  @override
  String get displayName => 'HDFC Bank';

  @override
  String get iconPath => 'assets/icons/providers/hdfc.png';

  @override
  String get aaBaseUrl => _aaBaseUrl;

  @override
  String get fipId => _fipId;
}

/// SS-014: ICICI Bank Linking
class IciciBankLinker extends BankLinker {
  static const _aaBaseUrl = String.fromEnvironment('AA_ICICI_BASE_URL');
  static const _fipId = String.fromEnvironment('AA_ICICI_FIP_ID');
  @override
  AccountProviderType get providerType => AccountProviderType.icici;

  @override
  String get displayName => 'ICICI Bank';

  @override
  String get iconPath => 'assets/icons/providers/icici.png';

  @override
  String get aaBaseUrl => _aaBaseUrl;

  @override
  String get fipId => _fipId;
}

/// SS-015: Axis Bank Linking
class AxisBankLinker extends BankLinker {
  static const _aaBaseUrl = String.fromEnvironment('AA_AXIS_BASE_URL');
  static const _fipId = String.fromEnvironment('AA_AXIS_FIP_ID');
  @override
  AccountProviderType get providerType => AccountProviderType.axis;

  @override
  String get displayName => 'Axis Bank';

  @override
  String get iconPath => 'assets/icons/providers/axis.png';

  @override
  String get aaBaseUrl => _aaBaseUrl;

  @override
  String get fipId => _fipId;
}

/// Factory for creating bank linkers
class BankLinkerFactory {
  static AccountLinker? create(AccountProviderType type) {
    switch (type) {
      case AccountProviderType.sbi:
        return SbiBankLinker();
      case AccountProviderType.hdfc:
        return HdfcBankLinker();
      case AccountProviderType.icici:
        return IciciBankLinker();
      case AccountProviderType.axis:
        return AxisBankLinker();
      default:
        return null;
    }
  }

  static List<AccountLinker> getAllBankLinkers() => [
        SbiBankLinker(),
        HdfcBankLinker(),
        IciciBankLinker(),
        AxisBankLinker(),
      ];
}

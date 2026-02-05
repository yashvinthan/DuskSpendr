import 'package:equatable/equatable.dart';

/// SS-010: Account Linker Architecture
/// Interface design, provider abstraction, error handling

/// Abstract interface for all account providers
abstract class AccountLinker {
  /// Provider type identifier
  AccountProviderType get providerType;

  /// Provider display name
  String get displayName;

  /// Provider icon asset path
  String get iconPath;

  /// Whether this provider supports real-time sync
  bool get supportsRealTimeSync;

  /// Initiate OAuth flow and return authorization URL
  Future<AuthorizationResult> initiateAuthorization();

  /// Exchange authorization code for tokens
  Future<TokenResult> exchangeAuthorizationCode(String code, String? verifier);

  /// Refresh access token using refresh token
  Future<TokenResult> refreshAccessToken(String refreshToken);

  /// Fetch transactions from provider
  Future<TransactionFetchResult> fetchTransactions({
    required String accessToken,
    DateTime? from,
    DateTime? to,
    String? cursor,
  });

  /// Fetch account balance
  Future<BalanceResult> fetchBalance(String accessToken);

  /// Revoke tokens and unlink
  Future<bool> revokeAccess(String accessToken);

  /// Handle provider-specific errors
  LinkingError handleError(dynamic error);
}

/// Account provider types
enum AccountProviderType {
  // Banks
  sbi(category: ProviderCategory.bank, name: 'State Bank of India'),
  hdfc(category: ProviderCategory.bank, name: 'HDFC Bank'),
  icici(category: ProviderCategory.bank, name: 'ICICI Bank'),
  axis(category: ProviderCategory.bank, name: 'Axis Bank'),

  // UPI Apps
  gpay(category: ProviderCategory.upi, name: 'Google Pay'),
  phonepe(category: ProviderCategory.upi, name: 'PhonePe'),
  paytmUpi(category: ProviderCategory.upi, name: 'Paytm UPI'),

  // Wallets
  amazonPay(category: ProviderCategory.wallet, name: 'Amazon Pay'),
  paytmWallet(category: ProviderCategory.wallet, name: 'Paytm Wallet'),

  // BNPL
  lazypay(category: ProviderCategory.bnpl, name: 'LazyPay'),
  simpl(category: ProviderCategory.bnpl, name: 'Simpl'),
  amazonPayLater(category: ProviderCategory.bnpl, name: 'Amazon Pay Later'),

  // Investment Platforms
  zerodha(category: ProviderCategory.investment, name: 'Zerodha Kite'),
  groww(category: ProviderCategory.investment, name: 'Groww'),
  upstox(category: ProviderCategory.investment, name: 'Upstox'),
  angelOne(category: ProviderCategory.investment, name: 'Angel One'),
  zerodhaCoins(category: ProviderCategory.investment, name: 'Coin by Zerodha'),
  indmoney(category: ProviderCategory.investment, name: 'INDmoney');

  final ProviderCategory category;
  final String name;

  const AccountProviderType({
    required this.category,
    required this.name,
  });

  String get iconPath => 'assets/icons/providers/${name.toLowerCase().replaceAll(' ', '_')}.png';
}

enum ProviderCategory {
  bank('Banks'),
  upi('UPI Apps'),
  wallet('Wallets'),
  bnpl('Buy Now Pay Later'),
  investment('Investment Platforms');

  final String displayName;
  const ProviderCategory(this.displayName);
}

/// Result of authorization initiation
class AuthorizationResult {
  final bool success;
  final String? authorizationUrl;
  final String? codeVerifier; // For PKCE
  final String? state;
  final String? error;

  const AuthorizationResult({
    required this.success,
    this.authorizationUrl,
    this.codeVerifier,
    this.state,
    this.error,
  });

  factory AuthorizationResult.success({
    required String authorizationUrl,
    String? codeVerifier,
    String? state,
  }) =>
      AuthorizationResult(
        success: true,
        authorizationUrl: authorizationUrl,
        codeVerifier: codeVerifier,
        state: state,
      );

  factory AuthorizationResult.failure(String error) => AuthorizationResult(
        success: false,
        error: error,
      );
}

/// Result of token exchange/refresh
class TokenResult {
  final bool success;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final String? error;
  final Map<String, dynamic>? metadata;

  const TokenResult({
    required this.success,
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.error,
    this.metadata,
  });

  factory TokenResult.success({
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    Map<String, dynamic>? metadata,
  }) =>
      TokenResult(
        success: true,
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
        metadata: metadata,
      );

  factory TokenResult.failure(String error) => TokenResult(
        success: false,
        error: error,
      );
}

/// Result of transaction fetch
class TransactionFetchResult {
  final bool success;
  final List<ProviderTransaction> transactions;
  final String? nextCursor;
  final bool hasMore;
  final String? error;

  const TransactionFetchResult({
    required this.success,
    this.transactions = const [],
    this.nextCursor,
    this.hasMore = false,
    this.error,
  });

  factory TransactionFetchResult.success({
    required List<ProviderTransaction> transactions,
    String? nextCursor,
    bool hasMore = false,
  }) =>
      TransactionFetchResult(
        success: true,
        transactions: transactions,
        nextCursor: nextCursor,
        hasMore: hasMore,
      );

  factory TransactionFetchResult.failure(String error) =>
      TransactionFetchResult(
        success: false,
        error: error,
      );
}

/// Transaction from external provider (before mapping to internal format)
class ProviderTransaction extends Equatable {
  final String providerId; // ID from the provider
  final int amountPaisa;
  final bool isDebit;
  final DateTime timestamp;
  final String? merchantName;
  final String? description;
  final String? referenceId;
  final String? upiId;
  final Map<String, dynamic>? rawData;

  const ProviderTransaction({
    required this.providerId,
    required this.amountPaisa,
    required this.isDebit,
    required this.timestamp,
    this.merchantName,
    this.description,
    this.referenceId,
    this.upiId,
    this.rawData,
  });

  @override
  List<Object?> get props => [providerId, amountPaisa, isDebit, timestamp];
}

/// Result of balance fetch
class BalanceResult {
  final bool success;
  final int? balancePaisa;
  final DateTime? updatedAt;
  final String? accountNumber;
  final String? error;

  const BalanceResult({
    required this.success,
    this.balancePaisa,
    this.updatedAt,
    this.accountNumber,
    this.error,
  });

  factory BalanceResult.success({
    required int balancePaisa,
    DateTime? updatedAt,
    String? accountNumber,
  }) =>
      BalanceResult(
        success: true,
        balancePaisa: balancePaisa,
        updatedAt: updatedAt ?? DateTime.now(),
        accountNumber: accountNumber,
      );

  factory BalanceResult.failure(String error) => BalanceResult(
        success: false,
        error: error,
      );
}

/// Linking error types
enum LinkingErrorType {
  networkError,
  authenticationFailed,
  tokenExpired,
  rateLimited,
  serverError,
  invalidResponse,
  userCanceled,
  mfaRequired,
  accountNotFound,
  permissionDenied,
  unknown,
}

/// Linking error with details
class LinkingError {
  final LinkingErrorType type;
  final String message;
  final String? details;
  final bool isRetryable;

  const LinkingError({
    required this.type,
    required this.message,
    this.details,
    this.isRetryable = false,
  });

  factory LinkingError.network([String? details]) => LinkingError(
        type: LinkingErrorType.networkError,
        message: 'Network error. Please check your connection.',
        details: details,
        isRetryable: true,
      );

  factory LinkingError.authFailed([String? details]) => LinkingError(
        type: LinkingErrorType.authenticationFailed,
        message: 'Authentication failed. Please try again.',
        details: details,
      );

  factory LinkingError.tokenExpired() => const LinkingError(
        type: LinkingErrorType.tokenExpired,
        message: 'Session expired. Please reconnect your account.',
      );

  factory LinkingError.rateLimited([String? details]) => LinkingError(
        type: LinkingErrorType.rateLimited,
        message: 'Too many requests. Please wait a moment.',
        details: details,
        isRetryable: true,
      );

  factory LinkingError.serverError([String? details]) => LinkingError(
        type: LinkingErrorType.serverError,
        message: 'Server error. Please try again later.',
        details: details,
        isRetryable: true,
      );

  factory LinkingError.mfaRequired() => const LinkingError(
        type: LinkingErrorType.mfaRequired,
        message: 'Additional verification required.',
      );

  factory LinkingError.canceled() => const LinkingError(
        type: LinkingErrorType.userCanceled,
        message: 'Linking was canceled.',
      );

  factory LinkingError.unknown([String? details]) => LinkingError(
        type: LinkingErrorType.unknown,
        message: 'An unexpected error occurred.',
        details: details,
      );
}

/// Linked account status
enum LinkedAccountStatus {
  active('Active', true),
  syncing('Syncing...', true),
  error('Error', false),
  expired('Expired', false),
  pending('Pending', false);

  final String displayName;
  final bool isHealthy;

  const LinkedAccountStatus(this.displayName, this.isHealthy);
}

/// Linked account entity
class LinkedAccountEntity extends Equatable {
  final String id;
  final AccountProviderType provider;
  final String? accountNumber;
  final String? accountName;
  final String? upiId;
  final int? balancePaisa;
  final DateTime? balanceUpdatedAt;
  final LinkedAccountStatus status;
  final DateTime lastSyncedAt;
  final DateTime linkedAt;
  final bool isPrimary;
  final Map<String, dynamic>? metadata;

  const LinkedAccountEntity({
    required this.id,
    required this.provider,
    this.accountNumber,
    this.accountName,
    this.upiId,
    this.balancePaisa,
    this.balanceUpdatedAt,
    required this.status,
    required this.lastSyncedAt,
    required this.linkedAt,
    this.isPrimary = false,
    this.metadata,
  });

  String get displayName {
    if (accountName != null && accountName!.isNotEmpty) return accountName!;
    if (upiId != null && upiId!.isNotEmpty) return upiId!;
    return provider.name;
  }

  LinkedAccountEntity copyWith({
    String? id,
    AccountProviderType? provider,
    String? accountNumber,
    String? accountName,
    String? upiId,
    int? balancePaisa,
    DateTime? balanceUpdatedAt,
    LinkedAccountStatus? status,
    DateTime? lastSyncedAt,
    DateTime? linkedAt,
    bool? isPrimary,
    Map<String, dynamic>? metadata,
  }) =>
      LinkedAccountEntity(
        id: id ?? this.id,
        provider: provider ?? this.provider,
        accountNumber: accountNumber ?? this.accountNumber,
        accountName: accountName ?? this.accountName,
        upiId: upiId ?? this.upiId,
        balancePaisa: balancePaisa ?? this.balancePaisa,
        balanceUpdatedAt: balanceUpdatedAt ?? this.balanceUpdatedAt,
        status: status ?? this.status,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        linkedAt: linkedAt ?? this.linkedAt,
        isPrimary: isPrimary ?? this.isPrimary,
        metadata: metadata ?? this.metadata,
      );

  @override
  List<Object?> get props => [
        id,
        provider,
        accountNumber,
        status,
        lastSyncedAt,
      ];
}

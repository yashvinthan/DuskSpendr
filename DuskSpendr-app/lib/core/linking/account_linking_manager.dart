import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'account_linker.dart';
import 'providers/bank_linkers.dart';
import 'providers/upi_linkers.dart';
import 'providers/wallet_bnpl_linkers.dart';
import 'providers/investment_linkers.dart';
import '../privacy/privacy_engine.dart';
import '../security/encryption_service.dart';
import '../../data/local/daos/account_dao.dart';
import '../../domain/entities/linked_account.dart' as domain;
import '../../domain/entities/money.dart';

/// SS-024, SS-025: Account Linking Manager
/// Manages linked accounts, token storage, unlinking with data cleanup
class AccountLinkingManager {
  final PrivacyEngine _privacyEngine;
  final AccountDao? _accountDao;
  final EncryptionService _encryptionService;
  static const _storage = FlutterSecureStorage();
  static const _tokensKey = 'linked_account_tokens';

  AccountLinkingManager({
    PrivacyEngine? privacyEngine,
    AccountDao? accountDao,
    EncryptionService? encryptionService,
  })  : _privacyEngine = privacyEngine ?? PrivacyEngine(),
        _accountDao = accountDao,
        _encryptionService = encryptionService ?? EncryptionService();

  // ====== Provider Factory ======

  /// Get linker for provider type
  AccountLinker? getLinker(AccountProviderType type) {
    // Try each factory
    return BankLinkerFactory.create(type) ??
        UpiLinkerFactory.create(type) ??
        WalletBnplLinkerFactory.create(type) ??
        InvestmentLinkerFactory.create(type);
  }

  /// Get all available linkers by category
  Map<ProviderCategory, List<AccountLinker>> getAllLinkersByCategory() {
    return {
      ProviderCategory.bank: BankLinkerFactory.getAllBankLinkers(),
      ProviderCategory.upi: UpiLinkerFactory.getAllUpiLinkers(),
      ProviderCategory.wallet: WalletBnplLinkerFactory.getAllWalletLinkers(),
      ProviderCategory.bnpl: WalletBnplLinkerFactory.getAllBnplLinkers(),
      ProviderCategory.investment: InvestmentLinkerFactory.getAllInvestmentLinkers(),
    };
  }

  // ====== Linking Flow ======

  /// Start the linking process for a provider
  Future<LinkingFlowResult> startLinking(AccountProviderType type) async {
    await _privacyEngine.logDataAccess(
      type: DataAccessType.write,
      entity: 'linked_account',
      details: 'Starting linking for ${type.name}',
    );

    final linker = getLinker(type);
    if (linker == null) {
      return LinkingFlowResult.failure('Provider not supported');
    }

    final authResult = await linker.initiateAuthorization();
    if (!authResult.success) {
      return LinkingFlowResult.failure(authResult.error ?? 'Authorization failed');
    }

    return LinkingFlowResult.pending(
      authorizationUrl: authResult.authorizationUrl!,
      codeVerifier: authResult.codeVerifier,
      state: authResult.state,
      provider: type,
    );
  }

  /// Complete the linking process after authorization callback
  Future<LinkingFlowResult> completeLinking({
    required AccountProviderType type,
    required String authorizationCode,
    String? codeVerifier,
    String? expectedState,
    String? receivedState,
  }) async {
    // Validate state if provided
    if (expectedState != null && receivedState != null) {
      if (expectedState != receivedState) {
        return LinkingFlowResult.failure('State mismatch - possible CSRF attack');
      }
    }

    final linker = getLinker(type);
    if (linker == null) {
      return LinkingFlowResult.failure('Provider not supported');
    }

    // Exchange code for tokens
    final tokenResult = await linker.exchangeAuthorizationCode(
      authorizationCode,
      codeVerifier,
    );

    if (!tokenResult.success) {
      return LinkingFlowResult.failure(tokenResult.error ?? 'Token exchange failed');
    }

    // Fetch initial balance
    BalanceResult? balanceResult;
    if (tokenResult.accessToken != null) {
      balanceResult = await linker.fetchBalance(tokenResult.accessToken!);
    }

    // Store tokens securely
    final storedAccountId = await _storeTokens(
      type,
      tokenResult,
      balanceResult: balanceResult,
    );

    await _privacyEngine.logDataAccess(
      type: DataAccessType.write,
      entity: 'linked_account',
      details: 'Completed linking for ${type.name}',
    );

    return LinkingFlowResult.success(
      provider: type,
      accessToken: tokenResult.accessToken!,
      refreshToken: tokenResult.refreshToken,
      expiresAt: tokenResult.expiresAt,
      balance: balanceResult?.balancePaisa,
      accountNumber: balanceResult?.accountNumber,
      metadata: {
        ...?tokenResult.metadata,
        if (storedAccountId != null) 'accountId': storedAccountId,
      },
    );
  }

  // ====== Token Management ======

  Future<String?> _storeTokens(
    AccountProviderType type,
    TokenResult result, {
    BalanceResult? balanceResult,
  }) async {
    final tokensJson = await _storage.read(key: _tokensKey);
    Map<String, dynamic> tokens = {};

    if (tokensJson != null) {
      tokens = jsonDecode(tokensJson);
    }

    tokens[type.name] = {
      'accessToken': result.accessToken,
      'refreshToken': result.refreshToken,
      'expiresAt': result.expiresAt?.toIso8601String(),
      'metadata': result.metadata,
      'linkedAt': DateTime.now().toIso8601String(),
    };

    await _storage.write(key: _tokensKey, value: jsonEncode(tokens));

    if (_accountDao == null) {
      return null;
    }

    final provider = _mapProvider(type);
    if (provider == null) {
      return null;
    }

    final encryptedAccess = result.accessToken != null
        ? await _encryptionService.encryptData(result.accessToken!)
        : null;
    final encryptedRefresh = result.refreshToken != null
        ? await _encryptionService.encryptData(result.refreshToken!)
        : null;

    final existing = await _accountDao!.getByProvider(provider);
    if (existing != null) {
      await _accountDao!.updateTokens(
        existing.id,
        accessToken: encryptedAccess,
        refreshToken: encryptedRefresh,
        expiresAt: result.expiresAt,
      );
      if (balanceResult?.balancePaisa != null) {
        await _accountDao!.updateBalance(
          existing.id,
          Money.fromPaisa(balanceResult!.balancePaisa!),
        );
      }
      return existing.id;
    }

    final account = domain.LinkedAccount(
      provider: provider,
      accountNumber: balanceResult?.accountNumber != null
          ? _privacyEngine.maskAccountNumber(balanceResult!.accountNumber!)
          : null,
      balance: balanceResult?.balancePaisa != null
          ? Money.fromPaisa(balanceResult!.balancePaisa!)
          : null,
      balanceUpdatedAt: balanceResult?.updatedAt,
      status: domain.AccountStatus.active,
      accessToken: encryptedAccess,
      refreshToken: encryptedRefresh,
      tokenExpiresAt: result.expiresAt,
      metadata: result.metadata,
    );

    await _accountDao!.insertAccount(account);
    return account.id;
  }

  /// Get stored tokens for a provider
  Future<StoredTokens?> getStoredTokens(AccountProviderType type) async {
    if (_accountDao != null) {
      final provider = _mapProvider(type);
      if (provider != null) {
        final account = await _accountDao!.getByProvider(provider);
        if (account != null) {
          return StoredTokens(
            accountId: account.id,
            accessToken: account.accessToken != null
                ? await _encryptionService.decryptData(account.accessToken!)
                : null,
            refreshToken: account.refreshToken != null
                ? await _encryptionService.decryptData(account.refreshToken!)
                : null,
            expiresAt: account.tokenExpiresAt,
            linkedAt: account.linkedAt,
            metadata: account.metadata,
          );
        }
      }
    }

    final tokensJson = await _storage.read(key: _tokensKey);
    if (tokensJson == null) return null;

    final tokens = jsonDecode(tokensJson);
    final providerTokens = tokens[type.name];
    if (providerTokens == null) return null;

    return StoredTokens(
      accountId: null,
      accessToken: providerTokens['accessToken'],
      refreshToken: providerTokens['refreshToken'],
      expiresAt: providerTokens['expiresAt'] != null
          ? DateTime.parse(providerTokens['expiresAt'])
          : null,
      linkedAt: DateTime.parse(providerTokens['linkedAt']),
      metadata: providerTokens['metadata'],
    );
  }

  /// Refresh tokens for a provider
  Future<bool> refreshTokens(AccountProviderType type) async {
    final storedTokens = await getStoredTokens(type);
    if (storedTokens?.refreshToken == null) return false;

    final linker = getLinker(type);
    if (linker == null) return false;

    final result = await linker.refreshAccessToken(storedTokens!.refreshToken!);
    if (!result.success) return false;

    await _storeTokens(type, result);
    return true;
  }

  /// Check if tokens are expired
  Future<bool> areTokensExpired(AccountProviderType type) async {
    final tokens = await getStoredTokens(type);
    if (tokens == null) return true;
    if (tokens.expiresAt == null) return false;
    return DateTime.now().isAfter(tokens.expiresAt!);
  }

  // ====== SS-024: Account Unlinking ======

  /// Unlink an account with complete data cleanup
  Future<UnlinkResult> unlinkAccount({
    required AccountProviderType type,
    required bool deleteTransactions,
    required String accountId,
  }) async {
    await _privacyEngine.logDataAccess(
      type: DataAccessType.delete,
      entity: 'linked_account',
      entityId: accountId,
      details: 'Unlinking ${type.name}, deleteTransactions: $deleteTransactions',
    );

    try {
      // 1. Revoke access tokens
      final tokens = await getStoredTokens(type);
      if (tokens?.accessToken != null) {
        final linker = getLinker(type);
        await linker?.revokeAccess(tokens!.accessToken!);
      }

      // 2. Remove stored tokens
      await _removeStoredTokens(type);

      // 3. Return info for database cleanup
      return UnlinkResult(
        success: true,
        provider: type,
        accountId: accountId,
        shouldDeleteTransactions: deleteTransactions,
      );
    } catch (e) {
      return UnlinkResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<void> _removeStoredTokens(AccountProviderType type) async {
    if (_accountDao != null) {
      final provider = _mapProvider(type);
      if (provider != null) {
        final account = await _accountDao!.getByProvider(provider);
        if (account != null) {
          await _accountDao!.updateTokens(
            account.id,
            accessToken: null,
            refreshToken: null,
            expiresAt: null,
          );
        }
      }
    }

    final tokensJson = await _storage.read(key: _tokensKey);
    if (tokensJson == null) return;

    final tokens = jsonDecode(tokensJson) as Map<String, dynamic>;
    tokens.remove(type.name);

    await _storage.write(key: _tokensKey, value: jsonEncode(tokens));
  }

  /// Get list of all linked provider types
  Future<List<AccountProviderType>> getLinkedProviders() async {
    if (_accountDao != null) {
      final accounts = await _accountDao!.getAll();
      return accounts
          .map((a) => _mapProviderType(a.provider))
          .whereType<AccountProviderType>()
          .toList();
    }

    final tokensJson = await _storage.read(key: _tokensKey);
    if (tokensJson == null) return [];

    final tokens = jsonDecode(tokensJson) as Map<String, dynamic>;
    return tokens.keys
        .map((name) {
          try {
            return AccountProviderType.values.byName(name);
          } catch (_) {
            return null;
          }
        })
        .whereType<AccountProviderType>()
        .toList();
  }

  // ====== Sync Operations ======

  /// Fetch transactions from a linked account
  Future<TransactionFetchResult> fetchTransactions({
    required AccountProviderType type,
    DateTime? from,
    DateTime? to,
    String? cursor,
  }) async {
    // Check and refresh tokens if needed
    if (await areTokensExpired(type)) {
      final refreshSuccess = await refreshTokens(type);
      if (!refreshSuccess) {
        return TransactionFetchResult.failure('Token expired, please re-link account');
      }
    }

    final tokens = await getStoredTokens(type);
    if (tokens?.accessToken == null) {
      return TransactionFetchResult.failure('No access token');
    }

    final linker = getLinker(type);
    if (linker == null) {
      return TransactionFetchResult.failure('Provider not supported');
    }

    await _privacyEngine.logDataAccess(
      type: DataAccessType.sync,
      entity: 'transactions',
      details: 'Fetching from ${type.name}',
    );

    return linker.fetchTransactions(
      accessToken: tokens!.accessToken!,
      from: from,
      to: to,
      cursor: cursor,
    );
  }

  /// Fetch balance from a linked account
  Future<BalanceResult> fetchBalance(AccountProviderType type) async {
    if (await areTokensExpired(type)) {
      final refreshSuccess = await refreshTokens(type);
      if (!refreshSuccess) {
        return BalanceResult.failure('Token expired');
      }
    }

    final tokens = await getStoredTokens(type);
    if (tokens?.accessToken == null) {
      return BalanceResult.failure('No access token');
    }

    final linker = getLinker(type);
    if (linker == null) {
      return BalanceResult.failure('Provider not supported');
    }

    return linker.fetchBalance(tokens!.accessToken!);
  }

  domain.AccountProvider? _mapProvider(AccountProviderType type) {
    try {
      return domain.AccountProvider.values.byName(type.name);
    } catch (_) {
      return null;
    }
  }

  AccountProviderType? _mapProviderType(domain.AccountProvider provider) {
    try {
      return AccountProviderType.values.byName(provider.name);
    } catch (_) {
      return null;
    }
  }
}

// ====== Data Classes ======

class LinkingFlowResult {
  final LinkingFlowStatus status;
  final AccountProviderType? provider;
  final String? authorizationUrl;
  final String? codeVerifier;
  final String? state;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final int? balance;
  final String? accountNumber;
  final Map<String, dynamic>? metadata;
  final String? error;

  const LinkingFlowResult({
    required this.status,
    this.provider,
    this.authorizationUrl,
    this.codeVerifier,
    this.state,
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.balance,
    this.accountNumber,
    this.metadata,
    this.error,
  });

  factory LinkingFlowResult.pending({
    required String authorizationUrl,
    String? codeVerifier,
    String? state,
    required AccountProviderType provider,
  }) =>
      LinkingFlowResult(
        status: LinkingFlowStatus.pending,
        provider: provider,
        authorizationUrl: authorizationUrl,
        codeVerifier: codeVerifier,
        state: state,
      );

  factory LinkingFlowResult.success({
    required AccountProviderType provider,
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    int? balance,
    String? accountNumber,
    Map<String, dynamic>? metadata,
  }) =>
      LinkingFlowResult(
        status: LinkingFlowStatus.success,
        provider: provider,
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
        balance: balance,
        accountNumber: accountNumber,
        metadata: metadata,
      );

  factory LinkingFlowResult.failure(String error) => LinkingFlowResult(
        status: LinkingFlowStatus.failed,
        error: error,
      );
}

enum LinkingFlowStatus { pending, success, failed }

class StoredTokens {
  final String? accountId;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final DateTime linkedAt;
  final Map<String, dynamic>? metadata;

  const StoredTokens({
    this.accountId,
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
    required this.linkedAt,
    this.metadata,
  });
}

class UnlinkResult {
  final bool success;
  final AccountProviderType? provider;
  final String? accountId;
  final bool shouldDeleteTransactions;
  final String? error;

  const UnlinkResult({
    required this.success,
    this.provider,
    this.accountId,
    this.shouldDeleteTransactions = false,
    this.error,
  });
}

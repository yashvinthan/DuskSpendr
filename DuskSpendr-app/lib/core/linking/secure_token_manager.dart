import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../security/encryption_service.dart';
import '../privacy/privacy_engine.dart';

/// Secure Token Manager for Account Linking
/// Handles OAuth token storage, refresh, and lifecycle
class SecureTokenManager {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  
  final EncryptionService _encryptionService;
  final PrivacyEngine _privacyEngine;

  // Token key prefixes
  static const _accessTokenPrefix = 'access_token_';
  static const _refreshTokenPrefix = 'refresh_token_';
  static const _tokenMetaPrefix = 'token_meta_';

  SecureTokenManager({
    EncryptionService? encryptionService,
    PrivacyEngine? privacyEngine,
  })  : _encryptionService = encryptionService ?? EncryptionService(),
        _privacyEngine = privacyEngine ?? PrivacyEngine();

  // ====== Token Storage ======

  /// Store tokens for an account
  Future<void> storeTokens({
    required String accountId,
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    Map<String, dynamic>? metadata,
  }) async {
    await _privacyEngine.logDataAccess(
      type: DataAccessType.write,
      entity: 'oauth_token',
      entityId: accountId,
      details: 'Storing tokens',
    );

    final encryptedAccess = await _encryptionService.encryptData(accessToken);
    await _storage.write(
      key: '$_accessTokenPrefix$accountId',
      value: encryptedAccess,
    );

    // Store refresh token if provided
    if (refreshToken != null) {
      final encryptedRefresh = await _encryptionService.encryptData(refreshToken);
      await _storage.write(
        key: '$_refreshTokenPrefix$accountId',
        value: encryptedRefresh,
      );
    }

    // Store token metadata
    final meta = TokenMetadata(
      accountId: accountId,
      expiresAt: expiresAt,
      createdAt: DateTime.now(),
      lastUsedAt: DateTime.now(),
      metadata: metadata,
    );
    await _storage.write(
      key: '$_tokenMetaPrefix$accountId',
      value: jsonEncode(meta.toJson()),
    );
  }

  /// Get access token for an account
  Future<String?> getAccessToken(String accountId) async {
    final token = await _storage.read(key: '$_accessTokenPrefix$accountId');
    
    if (token != null) {
      // Update last used time
      await _updateLastUsed(accountId);
      
      await _privacyEngine.logDataAccess(
        type: DataAccessType.read,
        entity: 'oauth_token',
        entityId: accountId,
        details: 'Access token read',
      );
    }
    
    if (token == null) return null;
    try {
      return await _encryptionService.decryptData(token);
    } catch (_) {
      return null;
    }
  }

  /// Get refresh token for an account
  Future<String?> getRefreshToken(String accountId) async {
    final token = await _storage.read(key: '$_refreshTokenPrefix$accountId');
    if (token == null) return null;
    try {
      return await _encryptionService.decryptData(token);
    } catch (_) {
      return null;
    }
  }

  /// Get token metadata
  Future<TokenMetadata?> getTokenMetadata(String accountId) async {
    final metaJson = await _storage.read(key: '$_tokenMetaPrefix$accountId');
    if (metaJson == null) return null;
    
    try {
      return TokenMetadata.fromJson(jsonDecode(metaJson));
    } catch (e) {
      return null;
    }
  }

  // ====== Token Lifecycle ======

  /// Check if tokens exist for an account
  Future<bool> hasTokens(String accountId) async {
    final token = await _storage.read(key: '$_accessTokenPrefix$accountId');
    return token != null;
  }

  /// Check if access token is expired
  Future<bool> isTokenExpired(String accountId) async {
    final meta = await getTokenMetadata(accountId);
    if (meta == null || meta.expiresAt == null) return true;
    
    // Consider expired if less than 5 minutes remaining
    const buffer = Duration(minutes: 5);
    return DateTime.now().isAfter(meta.expiresAt!.subtract(buffer));
  }

  /// Check if token needs refresh (approaching expiry)
  Future<bool> needsRefresh(String accountId) async {
    final meta = await getTokenMetadata(accountId);
    if (meta == null || meta.expiresAt == null) return true;
    
    // Refresh if less than 15 minutes remaining
    const threshold = Duration(minutes: 15);
    return DateTime.now().isAfter(meta.expiresAt!.subtract(threshold));
  }

  /// Update access token after refresh
  Future<void> updateAccessToken({
    required String accountId,
    required String newAccessToken,
    DateTime? newExpiresAt,
    String? newRefreshToken,
  }) async {
    final encryptedAccess = await _encryptionService.encryptData(newAccessToken);
    await _storage.write(
      key: '$_accessTokenPrefix$accountId',
      value: encryptedAccess,
    );

    if (newRefreshToken != null) {
      final encryptedRefresh = await _encryptionService.encryptData(newRefreshToken);
      await _storage.write(
        key: '$_refreshTokenPrefix$accountId',
        value: encryptedRefresh,
      );
    }

    // Update metadata
    final meta = await getTokenMetadata(accountId);
    if (meta != null) {
      final updatedMeta = TokenMetadata(
        accountId: accountId,
        expiresAt: newExpiresAt ?? meta.expiresAt,
        createdAt: meta.createdAt,
        lastUsedAt: DateTime.now(),
        refreshCount: meta.refreshCount + 1,
        metadata: meta.metadata,
      );
      await _storage.write(
        key: '$_tokenMetaPrefix$accountId',
        value: jsonEncode(updatedMeta.toJson()),
      );
    }

    await _privacyEngine.logDataAccess(
      type: DataAccessType.update,
      entity: 'oauth_token',
      entityId: accountId,
      details: 'Token refreshed',
    );
  }

  /// Revoke and delete tokens for an account
  Future<void> revokeTokens(String accountId) async {
    await _privacyEngine.logDataAccess(
      type: DataAccessType.delete,
      entity: 'oauth_token',
      entityId: accountId,
      details: 'Tokens revoked',
    );

    await _storage.delete(key: '$_accessTokenPrefix$accountId');
    await _storage.delete(key: '$_refreshTokenPrefix$accountId');
    await _storage.delete(key: '$_tokenMetaPrefix$accountId');
  }

  /// Revoke all tokens (full logout)
  Future<void> revokeAllTokens() async {
    await _privacyEngine.logDataAccess(
      type: DataAccessType.delete,
      entity: 'oauth_token',
      details: 'All tokens revoked',
    );

    // Get all keys and delete token-related ones
    final allKeys = await _storage.readAll();
    for (final key in allKeys.keys) {
      if (key.startsWith(_accessTokenPrefix) ||
          key.startsWith(_refreshTokenPrefix) ||
          key.startsWith(_tokenMetaPrefix)) {
        await _storage.delete(key: key);
      }
    }
  }

  // ====== Token Validation ======

  /// Validate token format (basic check)
  bool isValidTokenFormat(String token) {
    // JWT format check
    if (token.split('.').length == 3) return true;
    
    // Bearer token (alphanumeric with some special chars)
    if (RegExp(r'^[A-Za-z0-9_\-\.]+$').hasMatch(token)) return true;
    
    return token.length >= 20; // Minimum reasonable length
  }

  /// Get token stats for debugging
  Future<TokenStats> getStats() async {
    final allKeys = await _storage.readAll();
    int totalAccounts = 0;
    int expiredCount = 0;
    int activeCount = 0;

    for (final key in allKeys.keys) {
      if (key.startsWith(_accessTokenPrefix)) {
        totalAccounts++;
        final accountId = key.replaceFirst(_accessTokenPrefix, '');
        if (await isTokenExpired(accountId)) {
          expiredCount++;
        } else {
          activeCount++;
        }
      }
    }

    return TokenStats(
      totalAccounts: totalAccounts,
      activeTokens: activeCount,
      expiredTokens: expiredCount,
    );
  }

  // ====== Helpers ======

  Future<void> _updateLastUsed(String accountId) async {
    final meta = await getTokenMetadata(accountId);
    if (meta != null) {
      final updatedMeta = TokenMetadata(
        accountId: meta.accountId,
        expiresAt: meta.expiresAt,
        createdAt: meta.createdAt,
        lastUsedAt: DateTime.now(),
        refreshCount: meta.refreshCount,
        metadata: meta.metadata,
      );
      await _storage.write(
        key: '$_tokenMetaPrefix$accountId',
        value: jsonEncode(updatedMeta.toJson()),
      );
    }
  }
}

// ====== Models ======

class TokenMetadata {
  final String accountId;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime lastUsedAt;
  final int refreshCount;
  final Map<String, dynamic>? metadata;

  const TokenMetadata({
    required this.accountId,
    this.expiresAt,
    required this.createdAt,
    required this.lastUsedAt,
    this.refreshCount = 0,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'accountId': accountId,
        'expiresAt': expiresAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'lastUsedAt': lastUsedAt.toIso8601String(),
        'refreshCount': refreshCount,
        'metadata': metadata,
      };

  factory TokenMetadata.fromJson(Map<String, dynamic> json) => TokenMetadata(
        accountId: json['accountId'],
        expiresAt: json['expiresAt'] != null
            ? DateTime.parse(json['expiresAt'])
            : null,
        createdAt: DateTime.parse(json['createdAt']),
        lastUsedAt: DateTime.parse(json['lastUsedAt']),
        refreshCount: json['refreshCount'] ?? 0,
        metadata: json['metadata'],
      );

  Duration? get timeUntilExpiry {
    if (expiresAt == null) return null;
    return expiresAt!.difference(DateTime.now());
  }

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}

class TokenStats {
  final int totalAccounts;
  final int activeTokens;
  final int expiredTokens;

  const TokenStats({
    required this.totalAccounts,
    required this.activeTokens,
    required this.expiredTokens,
  });
}

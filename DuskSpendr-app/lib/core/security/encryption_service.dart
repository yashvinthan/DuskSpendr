import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encryption service for secure data storage
/// Manages encryption keys stored in secure keystore
class EncryptionService {
  static const _keyAlias = 'duskspendr_encryption_key';
  static const _pinHashAlias = 'duskspendr_pin_hash';

  final FlutterSecureStorage _storage;

  EncryptionService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  /// Generate new encryption key
  Future<String> generateEncryptionKey() async {
    final random = Random.secure();
    final bytes = Uint8List(32); // 256 bits
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(256);
    }
    final key = base64Encode(bytes);
    await _storage.write(key: _keyAlias, value: key);
    return key;
  }

  /// Get or create encryption key
  Future<String> getOrCreateEncryptionKey() async {
    var key = await _storage.read(key: _keyAlias);
    if (key == null) {
      key = await generateEncryptionKey();
    }
    return key;
  }

  Future<SecretKey> _getOrCreateSecretKey() async {
    final key = await getOrCreateEncryptionKey();
    final keyBytes = base64Decode(key);
    return SecretKey(keyBytes);
  }

  /// Delete encryption key (for complete data wipe)
  Future<void> deleteEncryptionKey() async {
    await _storage.delete(key: _keyAlias);
  }

  /// Store PIN hash
  Future<void> storePinHash(String hash) async {
    await _storage.write(key: _pinHashAlias, value: hash);
  }

  /// Get PIN hash
  Future<String?> getPinHash() async {
    return await _storage.read(key: _pinHashAlias);
  }

  /// Delete PIN hash
  Future<void> deletePinHash() async {
    await _storage.delete(key: _pinHashAlias);
  }

  /// Encrypt data for backups/exports
  Future<String> encryptData(String plaintext) async {
    final algorithm = AesGcm.with256bits();
    final secretKey = await _getOrCreateSecretKey();
    final nonce = algorithm.newNonce();
    final secretBox = await algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
      nonce: nonce,
    );

    final combined = <int>[
      ...nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ];
    return base64UrlEncode(combined);
  }

  /// Decrypt data for backups/exports
  Future<String> decryptData(String payload) async {
    final algorithm = AesGcm.with256bits();
    final secretKey = await _getOrCreateSecretKey();
    final combined = base64Url.decode(payload);

    const nonceLength = 12;
    const macLength = 16;
    if (combined.length <= nonceLength + macLength) {
      throw StateError('Invalid encrypted payload');
    }

    final nonce = combined.sublist(0, nonceLength);
    final macStart = combined.length - macLength;
    final cipherText = combined.sublist(nonceLength, macStart);
    final mac = Mac(combined.sublist(macStart));

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);
    final clearText = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );
    return utf8.decode(clearText);
  }

  /// Check if PIN is set
  Future<bool> isPinSet() async {
    final hash = await getPinHash();
    return hash != null && hash.isNotEmpty;
  }

  /// Store OAuth token (encrypted)
  Future<void> storeToken(String accountId, String token) async {
    await _storage.write(key: 'token_$accountId', value: token);
  }

  /// Get OAuth token
  Future<String?> getToken(String accountId) async {
    return await _storage.read(key: 'token_$accountId');
  }

  /// Delete OAuth token
  Future<void> deleteToken(String accountId) async {
    await _storage.delete(key: 'token_$accountId');
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Simple hash for PIN (use proper password hashing in production)
  String hashPin(String pin) {
    final bytes = utf8.encode(pin);
    var hash = 0;
    for (var byte in bytes) {
      hash = ((hash << 5) - hash) + byte;
      hash = hash & 0xffffffff;
    }
    return hash.toRadixString(16);
  }

  /// Verify PIN
  Future<bool> verifyPin(String pin) async {
    final storedHash = await getPinHash();
    if (storedHash == null) return false;
    return hashPin(pin) == storedHash;
  }
}

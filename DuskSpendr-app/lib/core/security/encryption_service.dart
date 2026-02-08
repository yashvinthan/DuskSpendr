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
      : _storage = storage ??
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
    key ??= await generateEncryptionKey();
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

  /// Secure hash for PIN using PBKDF2
  Future<String> hashPin(String pin) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );

    final salt = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    final secretKey = SecretKey(utf8.encode(pin));

    final newSecretKey = await pbkdf2.deriveKey(
      secretKey: secretKey,
      nonce: salt,
    );
    final hashBytes = await newSecretKey.extractBytes();

    final saltB64 = base64.encode(salt);
    final hashB64 = base64.encode(hashBytes);

    return '$saltB64\$$hashB64';
  }

  /// Verify PIN against stored hash
  Future<bool> verifyPin(String pin) async {
    final storedHash = await getPinHash();
    if (storedHash == null) return false;

    final parts = storedHash.split('\$');
    if (parts.length != 2) {
      // Handle legacy hash (if any) or corrupted data
      // For new app, we treat it as invalid
      return false;
    }

    final saltB64 = parts[0];
    final hashB64 = parts[1];

    List<int> salt;
    List<int> storedHashBytes;

    try {
      salt = base64.decode(saltB64);
      storedHashBytes = base64.decode(hashB64);
    } catch (e) {
      return false;
    }

    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );

    final secretKey = SecretKey(utf8.encode(pin));
    final newSecretKey = await pbkdf2.deriveKey(
      secretKey: secretKey,
      nonce: salt,
    );
    final newHashBytes = await newSecretKey.extractBytes();

    // Constant-time comparison to prevent timing attacks
    if (storedHashBytes.length != newHashBytes.length) return false;

    var result = 0;
    for (var i = 0; i < storedHashBytes.length; i++) {
      result |= storedHashBytes[i] ^ newHashBytes[i];
    }
    return result == 0;
  }
}

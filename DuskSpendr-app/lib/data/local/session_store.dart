import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure session storage. Uses platform secure storage (Android Keystore / iOS Keychain).
/// Tokens are never logged or written to plain storage.
class SessionStore {
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'auth_user_id';

  static const FlutterSecureStorage _defaultStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  final FlutterSecureStorage _storage;

  SessionStore({FlutterSecureStorage? storage})
      : _storage = storage ?? _defaultStorage;

  Future<void> saveSession({required String token, required String userId}) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<String?> readUserId() => _storage.read(key: _userIdKey);

  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
  }
}

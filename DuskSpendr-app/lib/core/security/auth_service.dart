import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

import 'encryption_service.dart';

/// Authentication result
enum AuthResult {
  success,
  failed,
  canceled,
  notAvailable,
  notEnrolled,
  lockedOut,
  permanentlyLockedOut,
}

/// Authentication service for biometric and PIN
class AuthService {
  final LocalAuthentication _localAuth;
  final EncryptionService _encryptionService;

  // Session management
  DateTime? _lastAuthTime;
  static const _sessionTimeout = Duration(minutes: 5);

  AuthService({
    LocalAuthentication? localAuth,
    EncryptionService? encryptionService,
  }) : _localAuth = localAuth ?? LocalAuthentication(),
       _encryptionService = encryptionService ?? EncryptionService();

  /// Check if biometric hardware is available
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  /// Check if device has biometrics enrolled
  Future<bool> hasBiometricsEnrolled() async {
    try {
      final biometrics = await _localAuth.getAvailableBiometrics();
      return biometrics.isNotEmpty;
    } on PlatformException {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Authenticate with biometrics
  Future<AuthResult> authenticateWithBiometrics({
    String reason = 'Authenticate to access DuskSpendr',
  }) async {
    try {
      final success = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (success) {
        _lastAuthTime = DateTime.now();
        return AuthResult.success;
      }
      return AuthResult.failed;
    } on PlatformException catch (e) {
      return _handlePlatformException(e);
    }
  }

  /// Authenticate with PIN
  Future<AuthResult> authenticateWithPin(String pin) async {
    final isValid = await _encryptionService.verifyPin(pin);
    if (isValid) {
      _lastAuthTime = DateTime.now();
      return AuthResult.success;
    }
    return AuthResult.failed;
  }

  /// Set up new PIN
  Future<void> setupPin(String pin) async {
    final hash = await _encryptionService.hashPin(pin);
    await _encryptionService.storePinHash(hash);
  }

  /// Change PIN
  Future<bool> changePin(String oldPin, String newPin) async {
    final isOldPinValid = await _encryptionService.verifyPin(oldPin);
    if (!isOldPinValid) return false;

    await setupPin(newPin);
    return true;
  }

  /// Check if PIN is set up
  Future<bool> isPinSetUp() async {
    return await _encryptionService.isPinSet();
  }

  /// Check if session is valid (not timed out)
  bool isSessionValid() {
    if (_lastAuthTime == null) return false;
    return DateTime.now().difference(_lastAuthTime!) < _sessionTimeout;
  }

  /// Invalidate session (logout)
  void invalidateSession() {
    _lastAuthTime = null;
  }

  /// Get auth method preference
  Future<AuthMethod> getPreferredAuthMethod() async {
    final hasBiometrics = await hasBiometricsEnrolled();
    final hasPin = await isPinSetUp();

    if (hasBiometrics) return AuthMethod.biometric;
    if (hasPin) return AuthMethod.pin;
    return AuthMethod.none;
  }

  /// Clear all auth data
  Future<void> clearAuth() async {
    await _encryptionService.deletePinHash();
    invalidateSession();
  }

  AuthResult _handlePlatformException(PlatformException e) {
    switch (e.code) {
      case 'NotAvailable':
        return AuthResult.notAvailable;
      case 'NotEnrolled':
        return AuthResult.notEnrolled;
      case 'LockedOut':
        return AuthResult.lockedOut;
      case 'PermanentlyLockedOut':
        return AuthResult.permanentlyLockedOut;
      default:
        return AuthResult.failed;
    }
  }
}

/// Authentication method preference
enum AuthMethod { biometric, pin, none }

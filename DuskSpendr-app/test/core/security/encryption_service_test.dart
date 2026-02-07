import 'package:flutter_test/flutter_test.dart';
import 'package:duskspendr/core/security/encryption_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

void main() {
  late EncryptionService encryptionService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Mock the MethodChannel for FlutterSecureStorage
    FlutterSecureStorage.setMockInitialValues({});

    encryptionService = EncryptionService();
  });

  group('EncryptionService PIN hashing', () {
    test('hashPin returns secure hash format', () async {
      final pin = '1234';
      final hash = await encryptionService.hashPin(pin);

      // Verify format: v1:salt:hash
      expect(hash, startsWith('v1:'));
      final parts = hash.split(':');
      expect(parts.length, equals(3));

      // Verify salt and hash are base64
      expect(() => base64Decode(parts[1]), returnsNormally);
      expect(() => base64Decode(parts[2]), returnsNormally);
    });

    test('Different salts produce different hashes for same PIN', () async {
      final pin = '1234';
      final hash1 = await encryptionService.hashPin(pin);
      final hash2 = await encryptionService.hashPin(pin);

      expect(hash1, isNot(equals(hash2)));

      // Verify verification works for both
      await encryptionService.storePinHash(hash1);
      expect(await encryptionService.verifyPin(pin), isTrue);

      await encryptionService.storePinHash(hash2);
      expect(await encryptionService.verifyPin(pin), isTrue);
    });

    test('verifyPin works with secure hash', () async {
      final pin = '1234';
      final hash = await encryptionService.hashPin(pin);
      await encryptionService.storePinHash(hash);

      final isValid = await encryptionService.verifyPin(pin);
      expect(isValid, isTrue);

      final isInvalid = await encryptionService.verifyPin('0000');
      expect(isInvalid, isFalse);
    });

    test('verifyPin works with legacy weak hash and migrates', () async {
      final pin = '1234';

      // Create legacy hash manually using the weak logic
      String weakHashPin(String p) {
        final bytes = utf8.encode(p);
        var h = 0;
        for (var byte in bytes) {
          h = ((h << 5) - h) + byte;
          h = h & 0xffffffff;
        }
        return h.toRadixString(16);
      }

      final legacyHash = weakHashPin(pin);

      // Store legacy hash
      await encryptionService.storePinHash(legacyHash);

      // Verify
      final isValid = await encryptionService.verifyPin(pin);
      expect(isValid, isTrue);

      // Check if migrated
      final storedHash = await encryptionService.getPinHash();
      expect(storedHash, isNot(equals(legacyHash)));
      expect(storedHash, startsWith('v1:'));

      // Verify the new migrated hash still works
      final isValidMigrated = await encryptionService.verifyPin(pin);
      expect(isValidMigrated, isTrue);
    });
  });
}

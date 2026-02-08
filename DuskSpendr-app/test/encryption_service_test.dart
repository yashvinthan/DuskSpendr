import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:duskspendr/core/security/encryption_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('hashPin generates different hashes for same PIN (salt usage)', () async {
    final service = EncryptionService();
    final pin = '1234';
    final hash1 = await service.hashPin(pin);
    final hash2 = await service.hashPin(pin);

    // Different salts mean different hashes
    expect(hash1, isNot(equals(hash2)));

    // But structure is same: salt$hash
    expect(hash1.split('\$').length, 2);
    expect(hash2.split('\$').length, 2);
  });

  test('verifyPin validates correct PIN', () async {
    final service = EncryptionService();
    final pin = '1234';
    final hash = await service.hashPin(pin);
    await service.storePinHash(hash);

    final isValid = await service.verifyPin(pin);
    expect(isValid, isTrue);
  });

  test('verifyPin rejects incorrect PIN', () async {
    final service = EncryptionService();
    final pin = '1234';
    final hash = await service.hashPin(pin);
    await service.storePinHash(hash);

    final isValid = await service.verifyPin('0000');
    expect(isValid, isFalse);
  });

  test('verifyPin handles missing hash', () async {
    final service = EncryptionService();
    // No hash stored
    final isValid = await service.verifyPin('1234');
    expect(isValid, isFalse);
  });

  test('verifyPin handles malformed hash', () async {
    final service = EncryptionService();
    await service.storePinHash('malformed_hash_string');
    final isValid = await service.verifyPin('1234');
    expect(isValid, isFalse);
  });
}

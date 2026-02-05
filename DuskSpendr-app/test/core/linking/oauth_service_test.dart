import 'package:flutter_test/flutter_test.dart';

import 'package:duskspendr/core/linking/oauth_service.dart';

void main() {
  group('OAuthService', () {
    test('generates verifier with expected length', () {
      final service = OAuthService();
      final verifier = service.generateCodeVerifier();
      expect(verifier.length, greaterThanOrEqualTo(43));
      expect(verifier.length, lessThanOrEqualTo(128));
    });

    test('generates consistent code challenge', () {
      final service = OAuthService();
      const verifier = 'test_verifier_1234567890_test_verifier_1234567890';
      final challenge1 = service.generateCodeChallenge(verifier);
      final challenge2 = service.generateCodeChallenge(verifier);
      expect(challenge1, equals(challenge2));
    });

    test('parses callback with success code', () {
      final service = OAuthService();
      final result = service.parseCallback(
        'duskspendr://oauth/callback?code=abc123&state=xyz',
      );
      expect(result.success, isTrue);
      expect(result.code, equals('abc123'));
      expect(result.state, equals('xyz'));
    });

    test('parses callback error as canceled', () {
      final service = OAuthService();
      final result = service.parseCallback(
        'duskspendr://oauth/callback?error=access_denied',
      );
      expect(result.success, isFalse);
      expect(result.isCanceled, isTrue);
    });

    test('validates state correctly', () {
      final service = OAuthService();
      expect(service.validateState('abc', 'abc'), isTrue);
      expect(service.validateState('abc', 'def'), isFalse);
    });
  });
}

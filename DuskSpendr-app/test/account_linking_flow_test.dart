import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:duskspendr/core/linking/account_linking_manager.dart';
import 'package:duskspendr/core/linking/account_linker.dart';
import 'package:duskspendr/core/linking/providers/bank_linkers.dart';
import 'package:duskspendr/core/linking/providers/upi_linkers.dart';
import 'package:duskspendr/core/privacy/privacy_engine.dart';
import 'package:duskspendr/data/local/daos/account_dao.dart';
import 'package:duskspendr/core/security/encryption_service.dart';
import 'package:duskspendr/domain/entities/linked_account.dart';
import 'package:duskspendr/domain/entities/money.dart';

// Fakes
class FakePrivacyEngine implements PrivacyEngine {
  @override
  Future<void> logDataAccess({
    required DataAccessType type,
    required String entity,
    String? entityId,
    String? details,
  }) async {
    // No-op
  }

  @override
  String maskAccountNumber(String accountNumber) {
    return 'XXXX' + accountNumber.substring(accountNumber.length - 4);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAccountDao implements AccountDao {
  final List<LinkedAccount> _accounts = [];

  @override
  Future<void> insertAccount(LinkedAccount account) async {
    _accounts.add(account);
  }

  @override
  Future<LinkedAccount?> getByProvider(AccountProvider provider) async {
    try {
      return _accounts.firstWhere((a) => a.provider == provider);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateTokens(
    String id, {
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) async {
    final index = _accounts.indexWhere((a) => a.id == id);
    if (index != -1) {
      _accounts[index] = _accounts[index].copyWith(
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenExpiresAt: expiresAt,
      );
    }
  }

  @override
  Future<void> updateBalance(String id, Money balance) async {
    final index = _accounts.indexWhere((a) => a.id == id);
    if (index != -1) {
      _accounts[index] = _accounts[index].copyWith(
        balance: balance,
      );
    }
  }

  @override
  Stream<List<LinkedAccount>> watchAll() {
      return Stream.value(_accounts);
  }

  @override
  Future<List<LinkedAccount>> getAll() async {
    return _accounts;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeEncryptionService implements EncryptionService {
  @override
  Future<String> encryptData(String data) async {
    return 'encrypted_$data';
  }

  @override
  Future<String> decryptData(String encryptedData) async {
    return encryptedData.replaceFirst('encrypted_', '');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('AccountLinkingManager Flow (Mock Mode)', () {
    late AccountLinkingManager manager;
    late FakePrivacyEngine mockPrivacyEngine;
    late FakeAccountDao mockAccountDao;
    late FakeEncryptionService mockEncryptionService;

    setUp(() {
      BankLinkerFactory.forceMockMode = true;
      UpiLinkerFactory.forceMockMode = true;

      mockPrivacyEngine = FakePrivacyEngine();
      mockAccountDao = FakeAccountDao();
      mockEncryptionService = FakeEncryptionService();

      manager = AccountLinkingManager(
        privacyEngine: mockPrivacyEngine,
        accountDao: mockAccountDao,
        encryptionService: mockEncryptionService,
      );
    });

    tearDown(() {
      BankLinkerFactory.forceMockMode = null;
      UpiLinkerFactory.forceMockMode = null;
    });

    test('SBI Linking Flow (Mock)', () async {
      // 1. Start Linking
      final startResult = await manager.startLinking(AccountProviderType.sbi);

      expect(startResult.status, LinkingFlowStatus.pending);
      expect(startResult.authorizationUrl, contains('duskspendr.mock'));
      expect(startResult.state, 'mock_state');

      // 2. Complete Linking
      final completeResult = await manager.completeLinking(
        type: AccountProviderType.sbi,
        authorizationCode: 'mock_code',
        codeVerifier: startResult.codeVerifier,
        expectedState: startResult.state,
        receivedState: 'mock_state',
      );

      expect(completeResult.status, LinkingFlowStatus.success);
      expect(completeResult.accessToken, 'mock_sbi_access_token');
      expect(completeResult.balance, greaterThan(0));

      // 3. Fetch Transactions
      final txResult = await manager.fetchTransactions(type: AccountProviderType.sbi);

      expect(txResult.success, isTrue);
      expect(txResult.transactions.length, greaterThan(0));
    });

    test('Google Pay Linking Flow (Mock)', () async {
      // 1. Start Linking
      final startResult = await manager.startLinking(AccountProviderType.gpay);

      expect(startResult.status, LinkingFlowStatus.pending);
      expect(startResult.authorizationUrl, contains('duskspendr.mock'));

      // 2. Complete Linking
      final completeResult = await manager.completeLinking(
        type: AccountProviderType.gpay,
        authorizationCode: 'mock_code',
        codeVerifier: startResult.codeVerifier,
        expectedState: startResult.state,
        receivedState: 'mock_state',
      );

      expect(completeResult.status, LinkingFlowStatus.success);
      expect(completeResult.accessToken, 'mock_gpay_access_token');

      // 3. Fetch Transactions
      final txResult = await manager.fetchTransactions(type: AccountProviderType.gpay);

      expect(txResult.success, isTrue);
      expect(txResult.transactions.length, greaterThan(0));
    });
  });
}

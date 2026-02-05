import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/daos/account_dao.dart';
import '../domain/entities/entities.dart';
import 'database_provider.dart';

/// Stream of all linked accounts
final linkedAccountsProvider = StreamProvider<List<LinkedAccount>>((ref) {
  final dao = ref.watch(accountDaoProvider);
  return dao.watchAll();
});

/// Total balance across all accounts
final totalBalanceProvider = FutureProvider<Money>((ref) async {
  final dao = ref.watch(accountDaoProvider);
  return await dao.getTotalBalance();
});

/// Primary account
final primaryAccountProvider = FutureProvider<LinkedAccount?>((ref) async {
  final dao = ref.watch(accountDaoProvider);
  return await dao.getPrimary();
});

/// Accounts by type
final accountsByTypeProvider =
    FutureProvider.family<List<LinkedAccount>, AccountType>((ref, type) async {
      final dao = ref.watch(accountDaoProvider);
      return await dao.getByType(type);
    });

/// Bank accounts only
final bankAccountsProvider = FutureProvider<List<LinkedAccount>>((ref) async {
  final dao = ref.watch(accountDaoProvider);
  return await dao.getByType(AccountType.bank);
});

/// UPI accounts only
final upiAccountsProvider = FutureProvider<List<LinkedAccount>>((ref) async {
  final dao = ref.watch(accountDaoProvider);
  return await dao.getByType(AccountType.upi);
});

/// Investment accounts only
final investmentAccountsProvider = FutureProvider<List<LinkedAccount>>((
  ref,
) async {
  final dao = ref.watch(accountDaoProvider);
  return await dao.getByType(AccountType.investment);
});

/// Account notifier for mutations
class AccountNotifier extends StateNotifier<AsyncValue<void>> {
  final AccountDao _dao;

  AccountNotifier(this._dao) : super(const AsyncValue.data(null));

  /// Link new account
  Future<void> linkAccount(LinkedAccount account) async {
    state = const AsyncValue.loading();
    try {
      await _dao.insertAccount(account);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update account
  Future<void> updateAccount(LinkedAccount account) async {
    state = const AsyncValue.loading();
    try {
      await _dao.updateAccount(account);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Unlink account
  Future<void> unlinkAccount(String id) async {
    state = const AsyncValue.loading();
    try {
      await _dao.deleteAccount(id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Set as primary
  Future<void> setPrimary(String id) async {
    state = const AsyncValue.loading();
    try {
      await _dao.setPrimary(id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update balance
  Future<void> updateBalance(String id, Money balance) async {
    try {
      await _dao.updateBalance(id, balance);
    } catch (_) {
      // Silent update, don't change state
    }
  }

  /// Update sync status
  Future<void> updateSyncStatus(String id, AccountStatus status) async {
    try {
      await _dao.updateSyncStatus(id, status);
    } catch (_) {
      // Silent update
    }
  }
}

/// Account mutation provider
final accountNotifierProvider =
    StateNotifierProvider<AccountNotifier, AsyncValue<void>>((ref) {
      final dao = ref.watch(accountDaoProvider);
      return AccountNotifier(dao);
    });

/// Account count for dashboard
final accountCountProvider = FutureProvider<int>((ref) async {
  final accounts = await ref.watch(linkedAccountsProvider.future);
  return accounts.length;
});

/// Accounts with stale sync
final staleSyncAccountsProvider = FutureProvider<List<LinkedAccount>>((
  ref,
) async {
  final accounts = await ref.watch(linkedAccountsProvider.future);
  return accounts.where((a) => a.isSyncStale).toList();
});

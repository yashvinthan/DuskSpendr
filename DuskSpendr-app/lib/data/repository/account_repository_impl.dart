import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../local/daos/account_dao.dart';

/// Implementation of AccountRepository using Drift database
class AccountRepositoryImpl implements AccountRepository {
  final AccountDao _dao;

  AccountRepositoryImpl(this._dao);

  @override
  Stream<List<LinkedAccount>> watchAccounts() => _dao.watchAll();

  @override
  Future<LinkedAccount?> getById(String id) => _dao.getById(id);

  @override
  Future<List<LinkedAccount>> getAll() => _dao.getAll();

  @override
  Future<List<LinkedAccount>> getActiveAccounts() async {
    final all = await _dao.getAll();
    return all.where((a) => a.status == AccountStatus.active).toList();
  }

  @override
  Future<LinkedAccount?> getPrimaryAccount() => _dao.getPrimary();

  @override
  Future<void> add(LinkedAccount account) => _dao.insertAccount(account);

  @override
  Future<void> update(LinkedAccount account) => _dao.updateAccount(account);

  @override
  Future<void> delete(String id) => _dao.deleteAccount(id);

  @override
  Future<void> setPrimary(String id) => _dao.setPrimary(id);

  @override
  Future<void> updateBalance(String id, Money balance) {
    return _dao.updateBalance(id, balance);
  }

  @override
  Future<Money> getTotalBalance() => _dao.getTotalBalance();
}

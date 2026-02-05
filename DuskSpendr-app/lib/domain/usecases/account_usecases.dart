import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case for managing linked accounts
class AccountUseCases {
  final AccountRepository _repository;

  AccountUseCases(this._repository);

  /// Watch all linked accounts
  Stream<List<LinkedAccount>> watchAccounts() {
    return _repository.watchAccounts();
  }

  /// Get all accounts
  Future<List<LinkedAccount>> getAccounts() async {
    return _repository.getAll();
  }

  /// Get active accounts only
  Future<List<LinkedAccount>> getActiveAccounts() async {
    return _repository.getActiveAccounts();
  }

  /// Get primary account
  Future<LinkedAccount?> getPrimaryAccount() async {
    return _repository.getPrimaryAccount();
  }

  /// Link a new account
  Future<void> linkAccount(LinkedAccount account) async {
    await _repository.add(account);
  }

  /// Update account details
  Future<void> updateAccount(LinkedAccount account) async {
    await _repository.update(account);
  }

  /// Unlink an account
  Future<void> unlinkAccount(String id) async {
    await _repository.delete(id);
  }

  /// Set account as primary
  Future<void> setAsPrimary(String id) async {
    await _repository.setPrimary(id);
  }

  /// Update account balance
  Future<void> updateBalance(String id, Money balance) async {
    await _repository.updateBalance(id, balance);
  }

  /// Get total balance across all accounts
  Future<Money> getTotalBalance() async {
    return _repository.getTotalBalance();
  }

  /// Get account by ID
  Future<LinkedAccount?> getAccount(String id) async {
    return _repository.getById(id);
  }
}

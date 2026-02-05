import '../entities/entities.dart';

/// Repository interface for linked account operations
abstract class AccountRepository {
  /// Watch all linked accounts
  Stream<List<LinkedAccount>> watchAccounts();

  /// Get a single account by ID
  Future<LinkedAccount?> getById(String id);

  /// Get all accounts
  Future<List<LinkedAccount>> getAll();

  /// Get active accounts only
  Future<List<LinkedAccount>> getActiveAccounts();

  /// Get primary account
  Future<LinkedAccount?> getPrimaryAccount();

  /// Add a new linked account
  Future<void> add(LinkedAccount account);

  /// Update an existing account
  Future<void> update(LinkedAccount account);

  /// Delete an account
  Future<void> delete(String id);

  /// Set account as primary
  Future<void> setPrimary(String id);

  /// Update account balance
  Future<void> updateBalance(String id, Money balance);

  /// Get total balance across all active accounts
  Future<Money> getTotalBalance();
}

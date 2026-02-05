import 'dart:convert';
import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';
import '../../../domain/entities/entities.dart';

part 'account_dao.g.dart';

/// Data Access Object for linked accounts
@DriftAccessor(tables: [LinkedAccounts])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(super.db);

  /// Watch all linked accounts
  Stream<List<LinkedAccount>> watchAll() {
    return (select(linkedAccounts)
          ..orderBy([
            (a) => OrderingTerm.desc(a.isPrimary),
            (a) => OrderingTerm.asc(a.linkedAt),
          ]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Get all accounts
  Future<List<LinkedAccount>> getAll() async {
    final rows = await (select(linkedAccounts)
          ..orderBy([
            (a) => OrderingTerm.desc(a.isPrimary),
            (a) => OrderingTerm.asc(a.linkedAt),
          ]))
        .get();
    return rows.map(_rowToEntity).toList();
  }

  /// Get account by ID
  Future<LinkedAccount?> getById(String id) async {
    final query = select(linkedAccounts)..where((a) => a.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _rowToEntity(row) : null;
  }

  /// Get account by provider
  Future<LinkedAccount?> getByProvider(AccountProvider provider) async {
    final query = select(linkedAccounts)
      ..where((a) => a.provider.equals(provider.index));
    final row = await query.getSingleOrNull();
    return row != null ? _rowToEntity(row) : null;
  }

  /// Get all accounts by provider
  Future<List<LinkedAccount>> getAllByProvider(AccountProvider provider) async {
    final rows = await (select(linkedAccounts)
          ..where((a) => a.provider.equals(provider.index)))
        .get();
    return rows.map(_rowToEntity).toList();
  }

  /// Get accounts by type
  Future<List<LinkedAccount>> getByType(AccountType type) async {
    // Filter providers by type
    final providerIndices = AccountProvider.values
        .where((p) => p.type == type)
        .map((p) => p.index)
        .toList();

    if (providerIndices.isEmpty) return [];

    final query = select(linkedAccounts)
      ..where(
        (a) => a.provider.isIn(
          providerIndices,
        ),
      );
    final rows = await query.get();
    return rows.map(_rowToEntity).toList();
  }

  /// Get primary account
  Future<LinkedAccount?> getPrimary() async {
    final query = select(linkedAccounts)
      ..where((a) => a.isPrimary.equals(true));
    final row = await query.getSingleOrNull();
    return row != null ? _rowToEntity(row) : null;
  }

  /// Get total balance across all accounts
  Future<Money> getTotalBalance() async {
    final rows = await select(linkedAccounts).get();
    final total = rows.fold<int>(
      0,
      (sum, row) => sum + (row.balancePaisa ?? 0),
    );
    return Money.fromPaisa(total);
  }

  /// Insert account
  Future<void> insertAccount(LinkedAccount account) async {
    // If this is set as primary, unset other primary accounts
    if (account.isPrimary) {
      await (update(linkedAccounts)..where((a) => a.isPrimary.equals(true)))
          .write(const LinkedAccountsCompanion(isPrimary: Value(false)));
    }
    await into(linkedAccounts).insert(_entityToRow(account));
  }

  /// Update account
  Future<void> updateAccount(LinkedAccount account) async {
    // If this is set as primary, unset other primary accounts
    if (account.isPrimary) {
      await (update(linkedAccounts)
            ..where((a) => a.isPrimary.equals(true))
            ..where((a) => a.id.isNotValue(account.id)))
          .write(const LinkedAccountsCompanion(isPrimary: Value(false)));
    }
    await (update(
      linkedAccounts,
    )..where((a) => a.id.equals(account.id)))
        .write(_entityToRow(account));
  }

  /// Update balance only
  Future<void> updateBalance(String id, Money balance) async {
    await (update(linkedAccounts)..where((a) => a.id.equals(id))).write(
      LinkedAccountsCompanion(
        balancePaisa: Value(balance.paisa),
        balanceUpdatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update sync status
  Future<void> updateSyncStatus(String id, AccountStatus status) async {
    await (update(linkedAccounts)..where((a) => a.id.equals(id))).write(
      LinkedAccountsCompanion(
        status: Value(AccountStatusDb.values[status.index]),
        lastSyncedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update tokens only
  Future<void> updateTokens(
    String id, {
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) async {
    await (update(linkedAccounts)..where((a) => a.id.equals(id))).write(
      LinkedAccountsCompanion(
        accessToken: Value(accessToken),
        refreshToken: Value(refreshToken),
        tokenExpiresAt: Value(expiresAt),
      ),
    );
  }

  /// Delete account and related data
  Future<void> deleteAccount(String id) async {
    await (delete(linkedAccounts)..where((a) => a.id.equals(id))).go();
  }

  /// Set account as primary
  Future<void> setPrimary(String id) async {
    await transaction(() async {
      // Unset all primary
      await (update(linkedAccounts)..where((a) => a.isPrimary.equals(true)))
          .write(const LinkedAccountsCompanion(isPrimary: Value(false)));
      // Set new primary
      await (update(linkedAccounts)..where((a) => a.id.equals(id))).write(
        const LinkedAccountsCompanion(isPrimary: Value(true)),
      );
    });
  }

  // Conversion helpers
  LinkedAccount _rowToEntity(LinkedAccountRow row) {
    return LinkedAccount(
      id: row.id,
      provider: AccountProvider.values[row.provider.index],
      accountNumber: row.accountNumber,
      accountName: row.accountName,
      upiId: row.upiId,
      balance:
          row.balancePaisa != null ? Money.fromPaisa(row.balancePaisa!) : null,
      balanceUpdatedAt: row.balanceUpdatedAt,
      status: AccountStatus.values[row.status.index],
      accessToken: row.accessToken,
      refreshToken: row.refreshToken,
      tokenExpiresAt: row.tokenExpiresAt,
      lastSyncedAt: row.lastSyncedAt,
      linkedAt: row.linkedAt,
      isPrimary: row.isPrimary,
      metadata: row.metadata != null ? jsonDecode(row.metadata!) : null,
    );
  }

  LinkedAccountsCompanion _entityToRow(LinkedAccount account) {
    return LinkedAccountsCompanion(
      id: Value(account.id),
      provider: Value(AccountProviderDb.values[account.provider.index]),
      accountNumber: Value(account.accountNumber),
      accountName: Value(account.accountName),
      upiId: Value(account.upiId),
      balancePaisa: Value(account.balance?.paisa),
      balanceUpdatedAt: Value(account.balanceUpdatedAt),
      status: Value(AccountStatusDb.values[account.status.index]),
      accessToken: Value(account.accessToken),
      refreshToken: Value(account.refreshToken),
      tokenExpiresAt: Value(account.tokenExpiresAt),
      lastSyncedAt: Value(account.lastSyncedAt),
      linkedAt: Value(account.linkedAt),
      isPrimary: Value(account.isPrimary),
      metadata: Value(
        account.metadata != null ? jsonEncode(account.metadata) : null,
      ),
    );
  }
}

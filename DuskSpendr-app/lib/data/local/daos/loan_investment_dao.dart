import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';
import '../../../core/budget/investment_tracker.dart' as tracker;

part 'loan_investment_dao.g.dart';

/// Data Access Object for loans (SS-068)
@DriftAccessor(tables: [Loans, LoanPayments, CreditCards])
class LoanDao extends DatabaseAccessor<AppDatabase> with _$LoanDaoMixin {
  LoanDao(super.db);

  /// Get all active loans
  Future<List<LoanRow>> getActiveLoans() async {
    final rows = await (select(loans)
          ..where((l) => l.isActive.equals(true))
          ..orderBy([(l) => OrderingTerm.asc(l.nextDueDate)]))
        .get();
    return rows;
  }

  /// Get loan by ID
  Future<LoanRow?> getById(String id) async {
    final query = select(loans)..where((l) => l.id.equals(id));
    return await query.getSingleOrNull();
  }

  /// Watch all active loans
  Stream<List<LoanRow>> watchActiveLoans() {
    return (select(loans)
          ..where((l) => l.isActive.equals(true))
          ..orderBy([(l) => OrderingTerm.asc(l.nextDueDate)]))
        .watch();
  }

  /// Insert loan
  Future<void> insertLoan(tracker.Loan loan) async {
    await into(loans).insert(LoansCompanion.insert(
      id: loan.id,
      name: loan.name,
      type: _typeToDb(loan.type),
      principalPaisa: loan.principalPaisa,
      outstandingPaisa: loan.outstandingPaisa,
      interestRatePercent: loan.interestRatePercent,
      emiPaisa: loan.emiPaisa,
      tenureMonths: loan.tenureMonths,
      totalPaidPaisa: Value(loan.totalPaidPaisa),
      startDate: loan.startDate,
      nextDueDate: Value(loan.nextDueDate),
      lastPaymentDate: Value(loan.lastPaymentDate),
      lenderName: const Value.absent(),
      isActive: const Value(true),
      notes: const Value.absent(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
  }

  /// Update loan
  Future<void> updateLoan(tracker.Loan loan) async {
    await (update(loans)..where((l) => l.id.equals(loan.id))).write(
      LoansCompanion(
        outstandingPaisa: Value(loan.outstandingPaisa),
        totalPaidPaisa: Value(loan.totalPaidPaisa),
        nextDueDate: Value(loan.nextDueDate),
        lastPaymentDate: Value(loan.lastPaymentDate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Record loan payment
  Future<void> recordPayment({
    required String loanId,
    required int amountPaisa,
    required int principalPaisa,
    required int interestPaisa,
  }) async {
    await into(loanPayments).insert(LoanPaymentsCompanion.insert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      loanId: loanId,
      amountPaisa: amountPaisa,
      principalPaidPaisa: principalPaisa,
      interestPaidPaisa: interestPaisa,
      paidAt: DateTime.now(),
    ));
  }

  /// Get payment history
  Future<List<LoanPaymentRow>> getPayments(String loanId) async {
    final rows = await (select(loanPayments)
          ..where((p) => p.loanId.equals(loanId))
          ..orderBy([(p) => OrderingTerm.desc(p.paidAt)]))
        .get();
    return rows;
  }

  /// Close loan
  Future<void> closeLoan(String id) async {
    await (update(loans)..where((l) => l.id.equals(id))).write(
      LoansCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete loan
  Future<void> deleteLoan(String id) async {
    await (delete(loans)..where((l) => l.id.equals(id))).go();
    await (delete(loanPayments)..where((p) => p.loanId.equals(id))).go();
  }

  // Credit cards

  /// Get all credit cards
  Future<List<CreditCardRow>> getCreditCards() async {
    return await select(creditCards).get();
  }

  /// Watch credit cards
  Stream<List<CreditCardRow>> watchCreditCards() {
    return select(creditCards).watch();
  }

  /// Insert credit card
  Future<void> insertCreditCard({
    required String id,
    required String name,
    required String lastFourDigits,
    required int creditLimitPaisa,
    required int dueDay,
    required int statementDay,
    required double interestRatePercent,
    String? bankName,
    bool isActive = true,
  }) async {
    await into(creditCards).insert(CreditCardsCompanion.insert(
      id: id,
      name: name,
      lastFourDigits: lastFourDigits,
      creditLimitPaisa: creditLimitPaisa,
      currentOutstandingPaisa: const Value(0),
      dueDay: dueDay,
      statementDay: statementDay,
      interestRatePercent: interestRatePercent,
      bankName: Value(bankName),
      isActive: Value(isActive),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
  }

  /// Update credit card outstanding
  Future<void> updateOutstanding(String id, int outstandingPaisa) async {
    await (update(creditCards)..where((c) => c.id.equals(id))).write(
      CreditCardsCompanion(
        currentOutstandingPaisa: Value(outstandingPaisa),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  LoanTypeDb _typeToDb(tracker.LoanType type) {
    switch (type) {
      case tracker.LoanType.personal:
        return LoanTypeDb.personal;
      case tracker.LoanType.education:
        return LoanTypeDb.education;
      case tracker.LoanType.vehicle:
        return LoanTypeDb.vehicle;
      case tracker.LoanType.home:
        return LoanTypeDb.home;
      case tracker.LoanType.creditCard:
        return LoanTypeDb.creditCard;
      case tracker.LoanType.bnpl:
        return LoanTypeDb.bnpl;
      case tracker.LoanType.other:
        return LoanTypeDb.other;
    }
  }
}

/// Data Access Object for investments (SS-069)
@DriftAccessor(tables: [Investments, InvestmentTransactions])
class InvestmentDao extends DatabaseAccessor<AppDatabase>
    with _$InvestmentDaoMixin {
  InvestmentDao(super.db);

  /// Get all investments
  Future<List<InvestmentRow>> getAll() async {
    return await select(investments).get();
  }

  /// Watch all investments
  Stream<List<InvestmentRow>> watchAll() {
    return (select(investments)
          ..orderBy([(i) => OrderingTerm.desc(i.currentValuePaisa)]))
        .watch();
  }

  /// Get investment by ID
  Future<InvestmentRow?> getById(String id) async {
    final query = select(investments)..where((i) => i.id.equals(id));
    return await query.getSingleOrNull();
  }

  /// Insert investment
  Future<void> insertInvestment(tracker.Investment investment) async {
    await into(investments).insert(InvestmentsCompanion.insert(
      id: investment.id,
      name: investment.name,
      type: _typeToDb(investment.type),
      platformId: Value(investment.platformId),
      investedPaisa: investment.investedPaisa,
      currentValuePaisa: investment.currentValuePaisa,
      units: Value(investment.units),
      startDate: investment.startDate,
      lastUpdated: investment.lastUpdated,
      notes: const Value.absent(),
      createdAt: DateTime.now(),
    ));
  }

  /// Update investment value
  Future<void> updateValue(String id, int currentValuePaisa) async {
    await (update(investments)..where((i) => i.id.equals(id))).write(
      InvestmentsCompanion(
        currentValuePaisa: Value(currentValuePaisa),
        lastUpdated: Value(DateTime.now()),
      ),
    );
  }

  /// Record investment transaction
  Future<void> recordTransaction({
    required String investmentId,
    required tracker.InvestmentTransactionType type,
    required int amountPaisa,
    required double units,
    required double pricePerUnit,
    String? notes,
  }) async {
    await into(investmentTransactions).insert(
      InvestmentTransactionsCompanion.insert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        investmentId: investmentId,
        type: _txTypeToDb(type),
        amountPaisa: amountPaisa,
        units: units,
        pricePerUnit: pricePerUnit,
        transactionDate: DateTime.now(),
        notes: Value(notes),
      ),
    );
  }

  /// Get transaction history
  Future<List<InvestmentTransactionRow>> getTransactions(
    String investmentId,
  ) async {
    final rows = await (select(investmentTransactions)
          ..where((t) => t.investmentId.equals(investmentId))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
    return rows;
  }

  /// Delete investment
  Future<void> deleteInvestment(String id) async {
    await (delete(investments)..where((i) => i.id.equals(id))).go();
    await (delete(investmentTransactions)
          ..where((t) => t.investmentId.equals(id)))
        .go();
  }

  /// Get portfolio summary
  Future<tracker.PortfolioSummary> getPortfolioSummary() async {
    final all = await getAll();
    int totalInvested = 0;
    int currentValue = 0;
    final allocationByType = <tracker.InvestmentType, int>{};

    for (final inv in all) {
      totalInvested += inv.investedPaisa;
      currentValue += inv.currentValuePaisa;
      final type = _typeFromDb(inv.type);
      allocationByType[type] = (allocationByType[type] ?? 0) + inv.currentValuePaisa;
    }

    final profitLoss = currentValue - totalInvested;
    final returnPercent =
        totalInvested > 0 ? (profitLoss / totalInvested) * 100 : 0.0;

    return tracker.PortfolioSummary(
      totalInvestedPaisa: totalInvested,
      totalCurrentValuePaisa: currentValue,
      totalGainLossPaisa: profitLoss,
      overallReturnPercent: returnPercent,
      investmentCount: all.length,
      allocationByType: allocationByType,
    );
  }

  InvestmentTypeDb _typeToDb(tracker.InvestmentType type) {
    switch (type) {
      case tracker.InvestmentType.mutualFund:
        return InvestmentTypeDb.mutualFund;
      case tracker.InvestmentType.stock:
        return InvestmentTypeDb.stock;
      case tracker.InvestmentType.etf:
        return InvestmentTypeDb.etf;
      case tracker.InvestmentType.fd:
        return InvestmentTypeDb.fd;
      case tracker.InvestmentType.rd:
        return InvestmentTypeDb.rd;
      case tracker.InvestmentType.ppf:
        return InvestmentTypeDb.ppf;
      case tracker.InvestmentType.nps:
        return InvestmentTypeDb.nps;
      case tracker.InvestmentType.gold:
        return InvestmentTypeDb.gold;
      case tracker.InvestmentType.crypto:
        return InvestmentTypeDb.crypto;
      case tracker.InvestmentType.other:
        return InvestmentTypeDb.other;
    }
  }

  tracker.InvestmentType _typeFromDb(InvestmentTypeDb type) {
    switch (type) {
      case InvestmentTypeDb.mutualFund:
        return tracker.InvestmentType.mutualFund;
      case InvestmentTypeDb.stock:
        return tracker.InvestmentType.stock;
      case InvestmentTypeDb.etf:
        return tracker.InvestmentType.etf;
      case InvestmentTypeDb.fd:
        return tracker.InvestmentType.fd;
      case InvestmentTypeDb.rd:
        return tracker.InvestmentType.rd;
      case InvestmentTypeDb.ppf:
        return tracker.InvestmentType.ppf;
      case InvestmentTypeDb.nps:
        return tracker.InvestmentType.nps;
      case InvestmentTypeDb.gold:
        return tracker.InvestmentType.gold;
      case InvestmentTypeDb.crypto:
        return tracker.InvestmentType.crypto;
      case InvestmentTypeDb.other:
        return tracker.InvestmentType.other;
    }
  }

  InvestmentTransactionTypeDb _txTypeToDb(
      tracker.InvestmentTransactionType type) {
    switch (type) {
      case tracker.InvestmentTransactionType.buy:
        return InvestmentTransactionTypeDb.buy;
      case tracker.InvestmentTransactionType.sell:
        return InvestmentTransactionTypeDb.sell;
    }
  }
}

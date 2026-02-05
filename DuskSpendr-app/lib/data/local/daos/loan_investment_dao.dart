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
  Future<List<LoanData>> getActiveLoans() async {
    final rows = await (select(loans)
          ..where((l) => l.isActive.equals(true))
          ..orderBy([(l) => OrderingTerm.asc(l.nextDueDate)]))
        .get();
    return rows;
  }

  /// Get loan by ID
  Future<LoanData?> getById(String id) async {
    final query = select(loans)..where((l) => l.id.equals(id));
    return await query.getSingleOrNull();
  }

  /// Watch all active loans
  Stream<List<LoanData>> watchActiveLoans() {
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
      lenderName: Value(loan.lenderName),
      loanType: _typeToDb(loan.type),
      principalPaisa: loan.principalPaisa,
      remainingPaisa: loan.remainingPaisa,
      interestRatePercent: loan.interestRatePercent,
      emiAmountPaisa: loan.emiAmountPaisa,
      tenureMonths: loan.tenureMonths,
      remainingMonths: loan.remainingMonths,
      startDate: loan.startDate,
      nextDueDate: Value(loan.nextDueDate),
      linkedAccountId: Value(loan.linkedAccountId),
      isActive: true,
      createdAt: DateTime.now(),
    ));
  }

  /// Update loan
  Future<void> updateLoan(tracker.Loan loan) async {
    await (update(loans)..where((l) => l.id.equals(loan.id))).write(
      LoansCompanion(
        remainingPaisa: Value(loan.remainingPaisa),
        remainingMonths: Value(loan.remainingMonths),
        nextDueDate: Value(loan.nextDueDate),
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
      principalPaisa: principalPaisa,
      interestPaisa: interestPaisa,
      paidAt: DateTime.now(),
    ));
  }

  /// Get payment history
  Future<List<LoanPaymentData>> getPayments(String loanId) async {
    final rows = await (select(loanPayments)
          ..where((p) => p.loanId.equals(loanId))
          ..orderBy([(p) => OrderingTerm.desc(p.paidAt)]))
        .get();
    return rows;
  }

  /// Close loan
  Future<void> closeLoan(String id) async {
    await (update(loans)..where((l) => l.id.equals(id))).write(
      const LoansCompanion(isActive: Value(false)),
    );
  }

  /// Delete loan
  Future<void> deleteLoan(String id) async {
    await (delete(loans)..where((l) => l.id.equals(id))).go();
    await (delete(loanPayments)..where((p) => p.loanId.equals(id))).go();
  }

  // Credit cards
  
  /// Get all credit cards
  Future<List<CreditCardData>> getCreditCards() async {
    return await select(creditCards).get();
  }

  /// Watch credit cards
  Stream<List<CreditCardData>> watchCreditCards() {
    return select(creditCards).watch();
  }

  /// Insert credit card
  Future<void> insertCreditCard({
    required String id,
    required String name,
    required String lastFourDigits,
    required int creditLimitPaisa,
    required int dueDay,
  }) async {
    await into(creditCards).insert(CreditCardsCompanion.insert(
      id: id,
      name: name,
      lastFourDigits: lastFourDigits,
      creditLimitPaisa: creditLimitPaisa,
      currentOutstandingPaisa: 0,
      dueDay: dueDay,
      createdAt: DateTime.now(),
    ));
  }

  /// Update credit card outstanding
  Future<void> updateOutstanding(String id, int outstandingPaisa) async {
    await (update(creditCards)..where((c) => c.id.equals(id))).write(
      CreditCardsCompanion(currentOutstandingPaisa: Value(outstandingPaisa)),
    );
  }

  LoanTypeDb _typeToDb(tracker.LoanType type) {
    switch (type) {
      case tracker.LoanType.personal: return LoanTypeDb.personal;
      case tracker.LoanType.education: return LoanTypeDb.education;
      case tracker.LoanType.vehicle: return LoanTypeDb.vehicle;
      case tracker.LoanType.home: return LoanTypeDb.home;
      case tracker.LoanType.creditCard: return LoanTypeDb.creditCard;
      case tracker.LoanType.bnpl: return LoanTypeDb.bnpl;
      case tracker.LoanType.other: return LoanTypeDb.other;
    }
  }
}

/// Data Access Object for investments (SS-069)
@DriftAccessor(tables: [Investments, InvestmentTransactions])
class InvestmentDao extends DatabaseAccessor<AppDatabase>
    with _$InvestmentDaoMixin {
  InvestmentDao(super.db);

  /// Get all investments
  Future<List<InvestmentData>> getAll() async {
    return await select(investments).get();
  }

  /// Watch all investments
  Stream<List<InvestmentData>> watchAll() {
    return (select(investments)
          ..orderBy([(i) => OrderingTerm.desc(i.currentValuePaisa)]))
        .watch();
  }

  /// Get investment by ID
  Future<InvestmentData?> getById(String id) async {
    final query = select(investments)..where((i) => i.id.equals(id));
    return await query.getSingleOrNull();
  }

  /// Insert investment
  Future<void> insertInvestment(tracker.Investment investment) async {
    await into(investments).insert(InvestmentsCompanion.insert(
      id: investment.id,
      name: investment.name,
      investmentType: _typeToDb(investment.type),
      investedAmountPaisa: investment.investedAmountPaisa,
      currentValuePaisa: investment.currentValuePaisa,
      unitsBought: Value(investment.unitsBought),
      purchaseDate: investment.purchaseDate,
      notes: Value(investment.notes),
      createdAt: DateTime.now(),
    ));
  }

  /// Update investment value
  Future<void> updateValue(String id, int currentValuePaisa) async {
    await (update(investments)..where((i) => i.id.equals(id))).write(
      InvestmentsCompanion(
        currentValuePaisa: Value(currentValuePaisa),
        lastUpdatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Record investment transaction
  Future<void> recordTransaction({
    required String investmentId,
    required tracker.InvestmentTransactionType type,
    required int amountPaisa,
    double? units,
    int? navPaisa,
  }) async {
    await into(investmentTransactions).insert(
      InvestmentTransactionsCompanion.insert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        investmentId: investmentId,
        transactionType: _txTypeToDb(type),
        amountPaisa: amountPaisa,
        units: Value(units),
        navPaisa: Value(navPaisa),
        transactionDate: DateTime.now(),
      ),
    );
  }

  /// Get transaction history
  Future<List<InvestmentTransactionData>> getTransactions(
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

    for (final inv in all) {
      totalInvested += inv.investedAmountPaisa;
      currentValue += inv.currentValuePaisa;
    }

    final profitLoss = currentValue - totalInvested;
    final returnPercent = totalInvested > 0
        ? (profitLoss / totalInvested) * 100
        : 0.0;

    return tracker.PortfolioSummary(
      totalInvestedPaisa: totalInvested,
      currentValuePaisa: currentValue,
      totalReturnPaisa: profitLoss,
      returnPercentage: returnPercent,
      dayChangePercent: 0.0, // Would need price history
      investments: [], // Load full details if needed
    );
  }

  InvestmentTypeDb _typeToDb(tracker.InvestmentType type) {
    switch (type) {
      case tracker.InvestmentType.mutualFund: return InvestmentTypeDb.mutualFund;
      case tracker.InvestmentType.stocks: return InvestmentTypeDb.stocks;
      case tracker.InvestmentType.fixedDeposit: return InvestmentTypeDb.fixedDeposit;
      case tracker.InvestmentType.ppf: return InvestmentTypeDb.ppf;
      case tracker.InvestmentType.nps: return InvestmentTypeDb.nps;
      case tracker.InvestmentType.gold: return InvestmentTypeDb.gold;
      case tracker.InvestmentType.crypto: return InvestmentTypeDb.crypto;
      case tracker.InvestmentType.other: return InvestmentTypeDb.other;
    }
  }

  InvestmentTransactionTypeDb _txTypeToDb(tracker.InvestmentTransactionType type) {
    switch (type) {
      case tracker.InvestmentTransactionType.buy: return InvestmentTransactionTypeDb.buy;
      case tracker.InvestmentTransactionType.sell: return InvestmentTransactionTypeDb.sell;
      case tracker.InvestmentTransactionType.dividend: return InvestmentTransactionTypeDb.dividend;
      case tracker.InvestmentTransactionType.sip: return InvestmentTransactionTypeDb.sip;
    }
  }
}

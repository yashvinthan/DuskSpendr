/// SS-068: Loan Tracking
/// SS-069: Investment Tracking
library;

/// Investment Portfolio Tracker
class InvestmentTracker {
  final Map<String, Investment> _investments = {};
  final List<InvestmentTransaction> _transactions = [];

  /// Add a new investment
  void addInvestment(Investment investment) {
    _investments[investment.id] = investment;
  }

  /// Record investment transaction (buy/sell)
  void recordTransaction(InvestmentTransaction transaction) {
    _transactions.add(transaction);
    
    final investment = _investments[transaction.investmentId];
    if (investment != null) {
      final updatedInvestment = investment.copyWith(
        currentValuePaisa: transaction.type == InvestmentTransactionType.buy
            ? investment.currentValuePaisa + transaction.amountPaisa
            : investment.currentValuePaisa - transaction.amountPaisa,
        units: transaction.type == InvestmentTransactionType.buy
            ? investment.units + transaction.units
            : investment.units - transaction.units,
        lastUpdated: DateTime.now(),
      );
      _investments[transaction.investmentId] = updatedInvestment;
    }
  }

  /// Calculate portfolio summary
  PortfolioSummary getPortfolioSummary() {
    int totalInvestedPaisa = 0;
    int totalCurrentValuePaisa = 0;
    final byType = <InvestmentType, int>{};

    for (final investment in _investments.values) {
      totalInvestedPaisa += investment.investedPaisa;
      totalCurrentValuePaisa += investment.currentValuePaisa;
      byType[investment.type] = 
          (byType[investment.type] ?? 0) + investment.currentValuePaisa;
    }

    final totalGainLossPaisa = totalCurrentValuePaisa - totalInvestedPaisa;
    final overallReturnPercent = totalInvestedPaisa > 0
        ? (totalGainLossPaisa / totalInvestedPaisa) * 100
        : 0.0;

    return PortfolioSummary(
      totalInvestedPaisa: totalInvestedPaisa,
      totalCurrentValuePaisa: totalCurrentValuePaisa,
      totalGainLossPaisa: totalGainLossPaisa,
      overallReturnPercent: overallReturnPercent,
      investmentCount: _investments.length,
      allocationByType: byType,
    );
  }

  /// Get individual investment performance
  InvestmentPerformance getPerformance(String investmentId) {
    final investment = _investments[investmentId];
    if (investment == null) {
      throw Exception('Investment not found');
    }

    final gainLoss = investment.currentValuePaisa - investment.investedPaisa;
    final returnPercent = investment.investedPaisa > 0
        ? (gainLoss / investment.investedPaisa) * 100
        : 0.0;

    // Calculate XIRR if we have transaction history
    final txns = _transactions.where((t) => t.investmentId == investmentId).toList();
    double? xirr;
    if (txns.length >= 2) {
      xirr = _calculateSimplifiedXirr(txns, investment.currentValuePaisa);
    }

    return InvestmentPerformance(
      investment: investment,
      absoluteGainLossPaisa: gainLoss,
      returnPercent: returnPercent,
      xirr: xirr,
    );
  }

  double? _calculateSimplifiedXirr(
    List<InvestmentTransaction> transactions,
    int currentValue,
  ) {
    // Simplified XIRR calculation
    if (transactions.isEmpty) return null;

    final sortedTxns = transactions..sort((a, b) => a.date.compareTo(b.date));
    final firstDate = sortedTxns.first.date;
    final lastDate = DateTime.now();
    final daysDiff = lastDate.difference(firstDate).inDays;

    if (daysDiff <= 0) return null;

    int totalInvested = 0;
    for (final txn in sortedTxns) {
      if (txn.type == InvestmentTransactionType.buy) {
        totalInvested += txn.amountPaisa;
      } else {
        totalInvested -= txn.amountPaisa;
      }
    }

    if (totalInvested <= 0) return null;

    final absoluteReturn = (currentValue - totalInvested) / totalInvested;
    final years = daysDiff / 365.0;
    
    // Annualized return
    if (years > 0) {
      return ((1 + absoluteReturn) * (1 / years) - 1) * 100;
    }
    return absoluteReturn * 100;
  }

  /// Get top gainers
  List<Investment> getTopGainers(int limit) {
    final list = _investments.values.toList();
    list.sort((a, b) {
      final gainA = a.currentValuePaisa - a.investedPaisa;
      final gainB = b.currentValuePaisa - b.investedPaisa;
      return gainB.compareTo(gainA);
    });
    return list.take(limit).toList();
  }

  /// Get top losers
  List<Investment> getTopLosers(int limit) {
    final list = _investments.values.toList();
    list.sort((a, b) {
      final lossA = a.investedPaisa - a.currentValuePaisa;
      final lossB = b.investedPaisa - b.currentValuePaisa;
      return lossB.compareTo(lossA);
    });
    return list.where((i) => i.currentValuePaisa < i.investedPaisa).take(limit).toList();
  }
}

/// Loan Tracker
class LoanTracker {
  final Map<String, Loan> _loans = {};
  final List<LoanPayment> _payments = [];

  /// Add a loan
  void addLoan(Loan loan) {
    _loans[loan.id] = loan;
  }

  /// Record a payment
  LoanPaymentResult recordPayment(LoanPayment payment) {
    final loan = _loans[payment.loanId];
    if (loan == null) {
      throw Exception('Loan not found');
    }

    _payments.add(payment);

    // Calculate new outstanding
    final interestPortion = (loan.outstandingPaisa * loan.interestRatePercent / 12 / 100).round();
    final principalPortion = payment.amountPaisa - interestPortion;
    final newOutstanding = loan.outstandingPaisa - principalPortion;

    final updatedLoan = loan.copyWith(
      outstandingPaisa: newOutstanding > 0 ? newOutstanding : 0,
      totalPaidPaisa: loan.totalPaidPaisa + payment.amountPaisa,
      lastPaymentDate: payment.date,
    );
    _loans[payment.loanId] = updatedLoan;

    return LoanPaymentResult(
      principalPaidPaisa: principalPortion,
      interestPaidPaisa: interestPortion,
      newOutstandingPaisa: updatedLoan.outstandingPaisa,
      remainingPayments: _calculateRemainingPayments(updatedLoan),
    );
  }

  int _calculateRemainingPayments(Loan loan) {
    if (loan.emiPaisa <= 0) return 0;
    return (loan.outstandingPaisa / loan.emiPaisa).ceil();
  }

  /// Get loan summary
  LoanSummary getLoanSummary() {
    int totalOutstanding = 0;
    int totalEmiDue = 0;
    final upcomingPayments = <UpcomingPayment>[];

    for (final loan in _loans.values) {
      totalOutstanding += loan.outstandingPaisa;
      totalEmiDue += loan.emiPaisa;

      if (loan.nextDueDate != null) {
        upcomingPayments.add(UpcomingPayment(
          loanId: loan.id,
          loanName: loan.name,
          amountPaisa: loan.emiPaisa,
          dueDate: loan.nextDueDate!,
        ));
      }
    }

    upcomingPayments.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return LoanSummary(
      totalLoans: _loans.length,
      totalOutstandingPaisa: totalOutstanding,
      totalMonthlyEmiPaisa: totalEmiDue,
      upcomingPayments: upcomingPayments,
    );
  }

  /// Get loan amortization schedule
  List<AmortizationEntry> getAmortizationSchedule(String loanId) {
    final loan = _loans[loanId];
    if (loan == null) return [];

    final schedule = <AmortizationEntry>[];
    var outstanding = loan.outstandingPaisa;
    var currentDate = DateTime.now();
    int month = 1;

    while (outstanding > 0 && month <= 360) { // Max 30 years
      final interestPaisa = (outstanding * loan.interestRatePercent / 12 / 100).round();
      final principalPaisa = loan.emiPaisa - interestPaisa;
      outstanding -= principalPaisa;

      schedule.add(AmortizationEntry(
        month: month,
        emiPaisa: loan.emiPaisa,
        principalPaisa: principalPaisa,
        interestPaisa: interestPaisa,
        outstandingPaisa: outstanding > 0 ? outstanding : 0,
        date: DateTime(currentDate.year, currentDate.month + month, currentDate.day),
      ));

      month++;
      if (outstanding <= 0) break;
    }

    return schedule;
  }

  /// Get loan insights
  LoanInsights getLoanInsights(String loanId) {
    final loan = _loans[loanId];
    if (loan == null) throw Exception('Loan not found');

    final schedule = getAmortizationSchedule(loanId);
    final totalInterest = schedule.fold<int>(0, (sum, e) => sum + e.interestPaisa);
    final totalPayment = loan.principalPaisa + totalInterest;

    // Calculate prepayment benefit
    final monthsRemaining = schedule.length;
    final interestSavedWithPrepayment = _calculatePrepaymentSavings(loan, 1);

    return LoanInsights(
      totalInterestPayablePaisa: totalInterest,
      totalPaymentPaisa: totalPayment,
      interestToPayRatio: totalInterest / loan.principalPaisa,
      monthsRemaining: monthsRemaining,
      estimatedClosureDate: schedule.isNotEmpty ? schedule.last.date : null,
      savingsWithOnePrepayment: interestSavedWithPrepayment,
    );
  }

  int _calculatePrepaymentSavings(Loan loan, int extraEmiCount) {
    // Simplified: 1 extra EMI saves roughly 2-3 EMIs worth of interest
    return (loan.emiPaisa * 2 * extraEmiCount * loan.interestRatePercent / 100).round();
  }
}

// ====== Data Classes ======

enum InvestmentType {
  mutualFund,
  stock,
  etf,
  fd,
  rd,
  ppf,
  nps,
  gold,
  crypto,
  other,
}

class Investment {
  final String id;
  final String name;
  final InvestmentType type;
  final String? platformId;
  final int investedPaisa;
  final int currentValuePaisa;
  final double units;
  final DateTime startDate;
  final DateTime lastUpdated;

  const Investment({
    required this.id,
    required this.name,
    required this.type,
    this.platformId,
    required this.investedPaisa,
    required this.currentValuePaisa,
    required this.units,
    required this.startDate,
    required this.lastUpdated,
  });

  Investment copyWith({
    String? id,
    String? name,
    InvestmentType? type,
    String? platformId,
    int? investedPaisa,
    int? currentValuePaisa,
    double? units,
    DateTime? startDate,
    DateTime? lastUpdated,
  }) =>
      Investment(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        platformId: platformId ?? this.platformId,
        investedPaisa: investedPaisa ?? this.investedPaisa,
        currentValuePaisa: currentValuePaisa ?? this.currentValuePaisa,
        units: units ?? this.units,
        startDate: startDate ?? this.startDate,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
}

enum InvestmentTransactionType { buy, sell }

class InvestmentTransaction {
  final String id;
  final String investmentId;
  final InvestmentTransactionType type;
  final int amountPaisa;
  final double units;
  final double pricePerUnit;
  final DateTime date;

  const InvestmentTransaction({
    required this.id,
    required this.investmentId,
    required this.type,
    required this.amountPaisa,
    required this.units,
    required this.pricePerUnit,
    required this.date,
  });
}

class PortfolioSummary {
  final int totalInvestedPaisa;
  final int totalCurrentValuePaisa;
  final int totalGainLossPaisa;
  final double overallReturnPercent;
  final int investmentCount;
  final Map<InvestmentType, int> allocationByType;

  const PortfolioSummary({
    required this.totalInvestedPaisa,
    required this.totalCurrentValuePaisa,
    required this.totalGainLossPaisa,
    required this.overallReturnPercent,
    required this.investmentCount,
    required this.allocationByType,
  });
}

class InvestmentPerformance {
  final Investment investment;
  final int absoluteGainLossPaisa;
  final double returnPercent;
  final double? xirr;

  const InvestmentPerformance({
    required this.investment,
    required this.absoluteGainLossPaisa,
    required this.returnPercent,
    this.xirr,
  });
}

enum LoanType {
  personal,
  education,
  vehicle,
  home,
  creditCard,
  bnpl,
  other,
}

class Loan {
  final String id;
  final String name;
  final LoanType type;
  final int principalPaisa;
  final int outstandingPaisa;
  final double interestRatePercent;
  final int emiPaisa;
  final int tenureMonths;
  final int totalPaidPaisa;
  final DateTime startDate;
  final DateTime? nextDueDate;
  final DateTime? lastPaymentDate;

  const Loan({
    required this.id,
    required this.name,
    required this.type,
    required this.principalPaisa,
    required this.outstandingPaisa,
    required this.interestRatePercent,
    required this.emiPaisa,
    required this.tenureMonths,
    required this.totalPaidPaisa,
    required this.startDate,
    this.nextDueDate,
    this.lastPaymentDate,
  });

  Loan copyWith({
    String? id,
    String? name,
    LoanType? type,
    int? principalPaisa,
    int? outstandingPaisa,
    double? interestRatePercent,
    int? emiPaisa,
    int? tenureMonths,
    int? totalPaidPaisa,
    DateTime? startDate,
    DateTime? nextDueDate,
    DateTime? lastPaymentDate,
  }) =>
      Loan(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        principalPaisa: principalPaisa ?? this.principalPaisa,
        outstandingPaisa: outstandingPaisa ?? this.outstandingPaisa,
        interestRatePercent: interestRatePercent ?? this.interestRatePercent,
        emiPaisa: emiPaisa ?? this.emiPaisa,
        tenureMonths: tenureMonths ?? this.tenureMonths,
        totalPaidPaisa: totalPaidPaisa ?? this.totalPaidPaisa,
        startDate: startDate ?? this.startDate,
        nextDueDate: nextDueDate ?? this.nextDueDate,
        lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      );
}

class LoanPayment {
  final String id;
  final String loanId;
  final int amountPaisa;
  final DateTime date;
  final bool isExtraPayment;

  const LoanPayment({
    required this.id,
    required this.loanId,
    required this.amountPaisa,
    required this.date,
    this.isExtraPayment = false,
  });
}

class LoanPaymentResult {
  final int principalPaidPaisa;
  final int interestPaidPaisa;
  final int newOutstandingPaisa;
  final int remainingPayments;

  const LoanPaymentResult({
    required this.principalPaidPaisa,
    required this.interestPaidPaisa,
    required this.newOutstandingPaisa,
    required this.remainingPayments,
  });
}

class LoanSummary {
  final int totalLoans;
  final int totalOutstandingPaisa;
  final int totalMonthlyEmiPaisa;
  final List<UpcomingPayment> upcomingPayments;

  const LoanSummary({
    required this.totalLoans,
    required this.totalOutstandingPaisa,
    required this.totalMonthlyEmiPaisa,
    required this.upcomingPayments,
  });
}

class UpcomingPayment {
  final String loanId;
  final String loanName;
  final int amountPaisa;
  final DateTime dueDate;

  const UpcomingPayment({
    required this.loanId,
    required this.loanName,
    required this.amountPaisa,
    required this.dueDate,
  });
}

class AmortizationEntry {
  final int month;
  final int emiPaisa;
  final int principalPaisa;
  final int interestPaisa;
  final int outstandingPaisa;
  final DateTime date;

  const AmortizationEntry({
    required this.month,
    required this.emiPaisa,
    required this.principalPaisa,
    required this.interestPaisa,
    required this.outstandingPaisa,
    required this.date,
  });
}

class LoanInsights {
  final int totalInterestPayablePaisa;
  final int totalPaymentPaisa;
  final double interestToPayRatio;
  final int monthsRemaining;
  final DateTime? estimatedClosureDate;
  final int savingsWithOnePrepayment;

  const LoanInsights({
    required this.totalInterestPayablePaisa,
    required this.totalPaymentPaisa,
    required this.interestToPayRatio,
    required this.monthsRemaining,
    this.estimatedClosureDate,
    required this.savingsWithOnePrepayment,
  });
}

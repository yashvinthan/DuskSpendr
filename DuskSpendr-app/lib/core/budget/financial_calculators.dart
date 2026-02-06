/// SS-070: Financial Calculators
library;
import 'dart:math';

/// Financial Calculators
class FinancialCalculators {
  /// EMI Calculator
  EmiResult calculateEmi({
    required int principalPaisa,
    required double annualRatePercent,
    required int tenureMonths,
  }) {
    final monthlyRate = annualRatePercent / 12 / 100;
    final principal = principalPaisa / 100;

    if (monthlyRate == 0) {
      final emi = principal / tenureMonths;
      return EmiResult(
        emiPaisa: (emi * 100).round(),
        totalPaymentPaisa: principalPaisa,
        totalInterestPaisa: 0,
      );
    }

    final emi = principal *
        monthlyRate *
        pow(1 + monthlyRate, tenureMonths) /
        (pow(1 + monthlyRate, tenureMonths) - 1);

    final totalPayment = emi * tenureMonths;
    final totalInterest = totalPayment - principal;

    return EmiResult(
      emiPaisa: (emi * 100).round(),
      totalPaymentPaisa: (totalPayment * 100).round(),
      totalInterestPaisa: (totalInterest * 100).round(),
    );
  }

  /// Compound Interest Calculator
  CompoundInterestResult calculateCompoundInterest({
    required int principalPaisa,
    required double annualRatePercent,
    required int years,
    int compoundingFrequency = 12, // Monthly
  }) {
    final principal = principalPaisa / 100;
    final rate = annualRatePercent / 100;
    final n = compoundingFrequency;

    final amount = principal * pow(1 + rate / n, n * years);
    final interest = amount - principal;

    return CompoundInterestResult(
      finalAmountPaisa: (amount * 100).round(),
      interestEarnedPaisa: (interest * 100).round(),
    );
  }

  /// SIP Returns Calculator
  SipResult calculateSipReturns({
    required int monthlyInvestmentPaisa,
    required double expectedAnnualReturnPercent,
    required int years,
  }) {
    final monthly = monthlyInvestmentPaisa / 100;
    final monthlyRate = expectedAnnualReturnPercent / 12 / 100;
    final months = years * 12;

    final futureValue = monthly *
        ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
        (1 + monthlyRate);

    final totalInvestment = monthly * months;
    final returns = futureValue - totalInvestment;

    return SipResult(
      totalInvestmentPaisa: (totalInvestment * 100).round(),
      estimatedReturnsPaisa: (returns * 100).round(),
      totalValuePaisa: (futureValue * 100).round(),
    );
  }

  /// Savings Goal Calculator
  SavingsGoalResult calculateMonthlySavings({
    required int goalAmountPaisa,
    required int currentSavingsPaisa,
    required int monthsToGoal,
    double expectedReturnPercent = 6.0,
  }) {
    final goal = goalAmountPaisa / 100;
    final current = currentSavingsPaisa / 100;
    final remaining = goal - current;
    final monthlyRate = expectedReturnPercent / 12 / 100;

    // PMT formula
    double monthlySavings;
    if (monthlyRate > 0) {
      monthlySavings =
          remaining * monthlyRate / (pow(1 + monthlyRate, monthsToGoal) - 1);
    } else {
      monthlySavings = remaining / monthsToGoal;
    }

    return SavingsGoalResult(
      requiredMonthlySavingsPaisa: (monthlySavings * 100).round(),
      totalContributionPaisa: (monthlySavings * monthsToGoal * 100).round(),
      projectedGoalDateMonths: monthsToGoal,
    );
  }
}

class EmiResult {
  final int emiPaisa;
  final int totalPaymentPaisa;
  final int totalInterestPaisa;

  const EmiResult({
    required this.emiPaisa,
    required this.totalPaymentPaisa,
    required this.totalInterestPaisa,
  });
}

class CompoundInterestResult {
  final int finalAmountPaisa;
  final int interestEarnedPaisa;

  const CompoundInterestResult({
    required this.finalAmountPaisa,
    required this.interestEarnedPaisa,
  });
}

class SipResult {
  final int totalInvestmentPaisa;
  final int estimatedReturnsPaisa;
  final int totalValuePaisa;

  const SipResult({
    required this.totalInvestmentPaisa,
    required this.estimatedReturnsPaisa,
    required this.totalValuePaisa,
  });
}

class SavingsGoalResult {
  final int requiredMonthlySavingsPaisa;
  final int totalContributionPaisa;
  final int projectedGoalDateMonths;

  const SavingsGoalResult({
    required this.requiredMonthlySavingsPaisa,
    required this.totalContributionPaisa,
    required this.projectedGoalDateMonths,
  });
}

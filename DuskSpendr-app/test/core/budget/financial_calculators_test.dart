import 'package:flutter_test/flutter_test.dart';
import 'package:duskspendr/core/budget/financial_calculators.dart';

void main() {
  late FinancialCalculators calculator;

  setUp(() {
    calculator = FinancialCalculators();
  });

  group('FinancialCalculators', () {
    group('calculateEmi', () {
      test('calculates correct EMI for standard inputs', () {
        // Principal: 10,000 INR (1,000,000 paisa)
        // Rate: 10%
        // Tenure: 12 months
        final result = calculator.calculateEmi(
          principalPaisa: 1000000,
          annualRatePercent: 10.0,
          tenureMonths: 12,
        );

        // EMI = 10000 * (0.10/12) * (1 + 0.10/12)^12 / ((1 + 0.10/12)^12 - 1)
        // Monthly Rate = 0.008333...
        // EMI ≈ 879.16 INR
        // EMI Paisa ≈ 87916
        expect(result.emiPaisa, closeTo(87916, 5)); // Allow small rounding diff
        expect(result.totalPaymentPaisa, greaterThan(1000000));
        expect(result.totalInterestPaisa, result.totalPaymentPaisa - 1000000);
      });

      test('calculates correct EMI for 0% interest', () {
        final result = calculator.calculateEmi(
          principalPaisa: 120000, // 1200 INR
          annualRatePercent: 0,
          tenureMonths: 12,
        );

        expect(result.emiPaisa, 10000); // 100 INR
        expect(result.totalPaymentPaisa, 120000);
        expect(result.totalInterestPaisa, 0);
      });
    });

    group('calculateCompoundInterest', () {
      test('calculates correct compound interest', () {
        // Principal: 10,000 INR
        // Rate: 5%
        // Years: 5
        final result = calculator.calculateCompoundInterest(
          principalPaisa: 1000000,
          annualRatePercent: 5.0,
          years: 5,
        );

        // A = 10000 * (1 + 0.05/12)^(12*5)
        // A ≈ 12833.59 INR
        // A Paisa ≈ 1283359
        expect(result.finalAmountPaisa, closeTo(1283359, 10));
        expect(result.interestEarnedPaisa, result.finalAmountPaisa - 1000000);
      });

      test('calculates compound interest with custom frequency', () {
        // Principal: 10,000 INR
        // Rate: 5%
        // Years: 5
        // Frequency: 1 (Annually)
        final result = calculator.calculateCompoundInterest(
          principalPaisa: 1000000,
          annualRatePercent: 5.0,
          years: 5,
          compoundingFrequency: 1,
        );

        // A = 10000 * (1 + 0.05)^5
        // A ≈ 12762.82 INR
        // A Paisa ≈ 1276282
        expect(result.finalAmountPaisa, closeTo(1276282, 10));
      });
    });

    group('calculateSipReturns', () {
      test('calculates correct SIP returns', () {
        // Monthly: 5,000 INR
        // Rate: 12%
        // Years: 10
        final result = calculator.calculateSipReturns(
          monthlyInvestmentPaisa: 500000,
          expectedAnnualReturnPercent: 12.0,
          years: 10,
        );

        // Standard SIP calculator (investment at start of period - Annuity Due)
        // Future Value = P * [ ( (1+r)^n - 1 ) / r ] * (1+r)
        // Monthly Rate r = 12% / 12 = 1% = 0.01
        // n = 120
        // FV = 5000 * [ ( (1.01)^120 - 1 ) / 0.01 ] * 1.01
        // FV = 5000 * [ (3.300386... - 1) / 0.01 ] * 1.01
        // FV = 5000 * 230.0386... * 1.01
        // FV = 1,161,695.42
        // Paisa = 116169542
        expect(result.totalInvestmentPaisa, 60000000);
        expect(result.totalValuePaisa, closeTo(116169542, 1000)); // Allow some leeway
      });
    });

    group('calculateMonthlySavings', () {
      test('calculates required savings for goal', () {
        // Goal: 100,000 INR
        // Current: 0
        // Months: 12
        // Rate: 6%
        final result = calculator.calculateMonthlySavings(
          goalAmountPaisa: 10000000,
          currentSavingsPaisa: 0,
          monthsToGoal: 12,
          expectedReturnPercent: 6.0,
        );

        // PMT = FV * r / ((1+r)^n - 1)
        // r = 0.5% = 0.005
        // n = 12
        // PMT = 100000 * 0.005 / ((1.005)^12 - 1)
        // PMT = 500 / (1.06167... - 1)
        // PMT = 500 / 0.061677...
        // PMT ≈ 8106.6
        // Wait, current logic:
        // monthlySavings = remaining * monthlyRate / (pow(1 + monthlyRate, monthsToGoal) - 1);
        // This is Ordinary Annuity (payments at end of period).
        // 8106.6 * 100 = 810660

        expect(result.requiredMonthlySavingsPaisa, closeTo(810660, 5000));
        expect(result.projectedGoalDateMonths, 12);
      });

      test('calculates required savings with 0% return', () {
        final result = calculator.calculateMonthlySavings(
          goalAmountPaisa: 120000,
          currentSavingsPaisa: 0,
          monthsToGoal: 12,
          expectedReturnPercent: 0,
        );

        expect(result.requiredMonthlySavingsPaisa, 10000);
      });

      test('calculates required savings with existing savings', () {
        // Goal: 100,000 INR
        // Current: 20,000 INR
        // Remaining: 80,000 INR
        // Months: 12
        // Rate: 0%
        final result = calculator.calculateMonthlySavings(
          goalAmountPaisa: 10000000,
          currentSavingsPaisa: 2000000,
          monthsToGoal: 12,
          expectedReturnPercent: 0,
        );

        // 80000 / 12 = 6666.66...
        // 666667 paisa
        expect(result.requiredMonthlySavingsPaisa, closeTo(666667, 5));
      });
    });
  });
}

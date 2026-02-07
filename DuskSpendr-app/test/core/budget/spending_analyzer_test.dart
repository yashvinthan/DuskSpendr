import 'package:flutter_test/flutter_test.dart';
import 'package:duskspendr/core/budget/budget_service.dart';

void main() {
  group('SpendingAnalyzer', () {
    final analyzer = SpendingAnalyzer();

    test('returns empty insights when transaction list is empty', () {
      final insights = analyzer.analyze([]);

      expect(insights.totalSpentPaisa, 0);
      expect(insights.averageTransactionPaisa, 0);
      expect(insights.categoryBreakdown, isEmpty);
      expect(insights.topMerchants, isEmpty);
      expect(insights.dailyPattern, isEmpty);
    });

    test('calculates total spent and average correctly for single transaction', () {
      final transactions = [
        TransactionSummary(
          id: '1',
          amountPaisa: 1000,
          date: DateTime(2023, 10, 27), // Friday
          category: 'Food',
          merchantName: 'BurgerKing',
        ),
      ];

      final insights = analyzer.analyze(transactions);

      expect(insights.totalSpentPaisa, 1000);
      expect(insights.averageTransactionPaisa, 1000);
      expect(insights.categoryBreakdown, {'Food': 1000});
      expect(insights.topMerchants, ['BurgerKing']);
      expect(insights.dailyPattern, {5: 1000});
    });

    test('calculates correct totals and averages for multiple transactions', () {
      final transactions = [
        TransactionSummary(
          id: '1',
          amountPaisa: 1000,
          date: DateTime(2023, 10, 27), // Friday
          category: 'Food',
          merchantName: 'BurgerKing',
        ),
        TransactionSummary(
          id: '2',
          amountPaisa: 2000,
          date: DateTime(2023, 10, 27), // Friday
          category: 'Transport',
          merchantName: 'Uber',
        ),
        TransactionSummary(
          id: '3',
          amountPaisa: 500,
          date: DateTime(2023, 10, 28), // Saturday
          category: 'Food',
          merchantName: 'McD',
        ),
      ];

      final insights = analyzer.analyze(transactions);

      expect(insights.totalSpentPaisa, 3500);
      expect(insights.averageTransactionPaisa, 1166); // 3500 / 3 = 1166
      expect(insights.categoryBreakdown, {
        'Food': 1500,
        'Transport': 2000,
      });
      expect(insights.topMerchants, ['Uber', 'BurgerKing', 'McD']);

      expect(insights.dailyPattern, {
        5: 3000, // Friday: 1000 + 2000
        6: 500,  // Saturday: 500
      });
    });

    test('identifies top merchants correctly and limits to 5', () {
      final transactions = List.generate(10, (index) {
        return TransactionSummary(
          id: '$index',
          amountPaisa: (index + 1) * 100,
          date: DateTime.now(),
          category: 'Misc',
          merchantName: 'Merchant $index',
        );
      });
      // Amounts: 100, 200, ..., 1000.
      // Top 5: 1000 (Merchant 9), 900 (Merchant 8), ..., 600 (Merchant 5)

      final insights = analyzer.analyze(transactions);

      expect(insights.topMerchants.length, 5);
      expect(insights.topMerchants, [
        'Merchant 9',
        'Merchant 8',
        'Merchant 7',
        'Merchant 6',
        'Merchant 5',
      ]);
    });

    test('handles transactions without merchant names', () {
       final transactions = [
        TransactionSummary(
          id: '1',
          amountPaisa: 1000,
          date: DateTime(2023, 10, 27),
          category: 'Food',
          merchantName: null,
        ),
        TransactionSummary(
          id: '2',
          amountPaisa: 2000,
          date: DateTime(2023, 10, 27),
          category: 'Transport',
          merchantName: 'Uber',
        ),
      ];

      final insights = analyzer.analyze(transactions);

      expect(insights.topMerchants, ['Uber']);
      expect(insights.totalSpentPaisa, 3000);
    });
  });
}

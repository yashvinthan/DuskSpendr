import 'package:flutter_test/flutter_test.dart';
import 'package:duskspendr/data/models/transaction_model.dart';

void main() {
  group('TransactionModel', () {
    test('amountLabel returns +₹10.00 for credit transaction', () {
      final transaction = TransactionModel(
        id: '1',
        amountPaisa: 1000,
        type: 'credit',
        category: 'Salary',
        timestamp: DateTime.now(),
        source: 'Bank',
      );
      expect(transaction.amountLabel, '+₹10.00');
    });

    test('amountLabel returns -₹5.50 for debit transaction', () {
      final transaction = TransactionModel(
        id: '2',
        amountPaisa: 550,
        type: 'debit',
        category: 'Food',
        timestamp: DateTime.now(),
        source: 'UPI',
      );
      expect(transaction.amountLabel, '-₹5.50');
    });

    test('amountLabel returns -₹0.00 for zero amount debit', () {
      final transaction = TransactionModel(
        id: '3',
        amountPaisa: 0,
        type: 'debit',
        category: 'Unknown',
        timestamp: DateTime.now(),
        source: 'Cash',
      );
      expect(transaction.amountLabel, '-₹0.00');
    });

    test('amountLabel returns +₹0.00 for zero amount credit', () {
      final transaction = TransactionModel(
        id: '4',
        amountPaisa: 0,
        type: 'credit',
        category: 'Unknown',
        timestamp: DateTime.now(),
        source: 'Bank',
      );
      expect(transaction.amountLabel, '+₹0.00');
    });

    test('amountLabel correctly formats large amounts', () {
      final transaction = TransactionModel(
        id: '5',
        amountPaisa: 123456789,
        type: 'credit',
        category: 'Refund',
        timestamp: DateTime.now(),
        source: 'Bank',
      );
      expect(transaction.amountLabel, '+₹1234567.89');
    });

    test('fromJson correctly parses JSON', () {
      final timestamp = DateTime.now();
      final json = {
        'id': '6',
        'amount_paisa': 1500,
        'type': 'debit',
        'category': 'Transport',
        'timestamp': timestamp.toIso8601String(),
        'source': 'Wallet',
        'merchant_name': 'Uber',
        'description': 'Ride home',
      };

      final transaction = TransactionModel.fromJson(json);

      expect(transaction.id, '6');
      expect(transaction.amountPaisa, 1500);
      expect(transaction.type, 'debit');
      expect(transaction.category, 'Transport');
      expect(transaction.source, 'Wallet');
      expect(transaction.merchantName, 'Uber');
      expect(transaction.description, 'Ride home');
      expect(transaction.timestamp, timestamp);
      expect(transaction.amountLabel, '-₹15.00');
    });
  });
}

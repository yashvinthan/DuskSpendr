import 'package:flutter_test/flutter_test.dart';
import 'package:duskspendr/data/models/transaction_model.dart';

void main() {
  group('TransactionModel', () {
    test('lowerCategory and lowerMerchantName should be correct', () {
      final tx = TransactionModel(
        id: '1',
        amountPaisa: 1000,
        type: 'debit',
        category: 'Food',
        timestamp: DateTime.now(),
        source: 'Bank',
        merchantName: 'Starbucks',
        description: 'Coffee',
      );

      // Verify cached lowercased properties
      expect(tx.lowerCategory, 'food');
      expect(tx.lowerMerchantName, 'starbucks');
    });

    test('lowerMerchantName should be null if merchantName is null', () {
      final tx = TransactionModel(
        id: '1',
        amountPaisa: 1000,
        type: 'debit',
        category: 'Food',
        timestamp: DateTime.now(),
        source: 'Bank',
        merchantName: null,
        description: 'Coffee',
      );

      expect(tx.lowerCategory, 'food');
      expect(tx.lowerMerchantName, null);
    });
  });
}

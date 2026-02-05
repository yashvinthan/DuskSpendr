// Placeholder types for DAO compilation
class BalanceSource {
  static const values = [BalanceSource()];
  final int index;
  const BalanceSource([this.index = 0]);
}
class BalanceSnapshotData {
  String id = '';
  String accountId = '';
  int balancePaisa = 0;
  int source = 0;
  int recordedAt = 0;
}
class BillReminderData {
  String id = '';
  String name = '';
  String merchantName = '';
  int amountPaisa = 0;
  String frequency = '';
  String billType = '';
  DateTime nextDueDate = DateTime.now();
  int reminderDaysBefore = 0;
  bool isAutoDetected = false;
  bool isActive = false;
  String linkedAccountId = '';
  String notes = '';
  DateTime createdAt = DateTime.now();
}
class BillPaymentData {
  String id = '';
  String billId = '';
  int amountPaisa = 0;
  DateTime paidAt = DateTime.now();
  String transactionId = '';
  bool isAutoLinked = false;
}
class LoanData {}
class LoanPaymentData {}
class CreditCardData {}
class InvestmentData {}
class InvestmentTransactionData {}

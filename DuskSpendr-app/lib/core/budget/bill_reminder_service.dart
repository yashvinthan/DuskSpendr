import 'dart:async';

import '../../data/local/database.dart';
import '../../domain/entities/entities.dart';
import '../notifications/notification_service.dart';

/// SS-067: Bill Payment Reminder Service
/// Auto-detect bills, send reminders, track payment history

class BillReminderService {
  final AppDatabase _database;
  final NotificationService _notificationService;

  Timer? _reminderTimer;
  final _billController = StreamController<List<BillReminder>>.broadcast();
  final _alertController = StreamController<BillReminderAlert>.broadcast();

  Stream<List<BillReminder>> get bills => _billController.stream;
  Stream<BillReminderAlert> get alerts => _alertController.stream;

  BillReminderService({
    required AppDatabase database,
    required NotificationService notificationService,
  })  : _database = database,
        _notificationService = notificationService;

  // ====== Bill Detection ======

  /// Detect recurring bills from transaction history
  Future<List<BillReminder>> detectBillsFromTransactions(
    List<Transaction> transactions,
  ) async {
    final bills = <BillReminder>[];

    // Group by merchant (debit transactions only)
    final byMerchant = <String, List<Transaction>>{};
    for (final tx in transactions) {
      if (tx.type == TransactionType.debit && tx.merchantName != null) {
        byMerchant.putIfAbsent(tx.merchantName!, () => []).add(tx);
      }
    }

    for (final entry in byMerchant.entries) {
      if (entry.value.length < 2) continue;

      final txList = entry.value..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Check for consistent amounts (within 10%)
      final amounts = txList.map((t) => t.amount.paisa).toList();
      final avgAmount = amounts.reduce((a, b) => a + b) / amounts.length;
      final isConsistent = amounts.every((a) => (a - avgAmount).abs() < avgAmount * 0.1);

      if (!isConsistent) continue;

      // Calculate intervals
      final intervals = <int>[];
      for (int i = 1; i < txList.length; i++) {
        intervals.add(txList[i].timestamp.difference(txList[i - 1].timestamp).inDays);
      }

      if (intervals.isEmpty) continue;

      final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
      final intervalVariance = intervals.map((i) => (i - avgInterval).abs()).reduce((a, b) => a + b) / intervals.length;

      // Only consider if interval variance is low (< 5 days)
      if (intervalVariance > 5) continue;

      // Determine frequency
      final frequency = _determineFrequency(avgInterval);
      if (frequency == null) continue;

      // Calculate next due date
      final lastTx = txList.last;
      final nextDue = _calculateNextDue(lastTx.timestamp, avgInterval.round());

      // Determine bill type
      final billType = _detectBillType(entry.key);

      bills.add(BillReminder(
        id: '${entry.key.hashCode}',
        name: _formatBillName(entry.key, billType),
        merchantName: entry.key,
        amountPaisa: avgAmount.round(),
        frequency: frequency,
        billType: billType,
        nextDueDate: nextDue,
        reminderDaysBefore: 3,
        isAutoDetected: true,
        isActive: true,
        paymentHistory: txList.map((t) => BillPayment(
          id: t.id,
          billId: entry.key.hashCode.toString(),
          amountPaisa: t.amount.paisa,
          paidAt: t.timestamp,
          isAutoLinked: true,
        )).toList(),
        createdAt: DateTime.now(),
      ));
    }

    return bills;
  }

  BillFrequency? _determineFrequency(double avgDays) {
    if (avgDays >= 6 && avgDays <= 8) return BillFrequency.weekly;
    if (avgDays >= 13 && avgDays <= 16) return BillFrequency.biweekly;
    if (avgDays >= 25 && avgDays <= 35) return BillFrequency.monthly;
    if (avgDays >= 80 && avgDays <= 100) return BillFrequency.quarterly;
    if (avgDays >= 350 && avgDays <= 380) return BillFrequency.yearly;
    return null;
  }

  DateTime _calculateNextDue(DateTime lastPayment, int intervalDays) {
    var next = lastPayment.add(Duration(days: intervalDays));
    // If already passed, add another interval
    while (next.isBefore(DateTime.now())) {
      next = next.add(Duration(days: intervalDays));
    }
    return next;
  }

  BillType _detectBillType(String merchantName) {
    final nameLower = merchantName.toLowerCase();

    // Phone/Telecom
    if (_matchesAny(nameLower, ['airtel', 'jio', 'vodafone', 'vi', 'bsnl', 'mtnl'])) {
      return BillType.phoneRecharge;
    }

    // Electricity
    if (_matchesAny(nameLower, ['bescom', 'mseb', 'tneb', 'pgvcl', 'electricity', 'power', 'vidyut'])) {
      return BillType.electricity;
    }

    // Internet
    if (_matchesAny(nameLower, ['actfibernet', 'act ', 'hathway', 'tikona', 'broadband', 'fiber'])) {
      return BillType.internet;
    }

    // Subscriptions
    if (_matchesAny(nameLower, ['netflix', 'hotstar', 'prime', 'spotify', 'youtube', 'apple', 'google play', 'disney'])) {
      return BillType.subscription;
    }

    // Credit Card
    if (_matchesAny(nameLower, ['hdfc card', 'icici card', 'axis card', 'sbi card', 'amex', 'credit card'])) {
      return BillType.creditCard;
    }

    // Loan EMI
    if (_matchesAny(nameLower, ['emi', 'loan', 'bajaj finserv', 'home credit', 'tata capital'])) {
      return BillType.loanEmi;
    }

    // Rent
    if (_matchesAny(nameLower, ['rent', 'landlord', 'housing', 'pg ', 'hostel'])) {
      return BillType.rent;
    }

    // Insurance
    if (_matchesAny(nameLower, ['lic', 'insurance', 'hdfc life', 'max life', 'icici pru'])) {
      return BillType.insurance;
    }

    return BillType.other;
  }

  bool _matchesAny(String text, List<String> patterns) {
    return patterns.any((p) => text.contains(p));
  }

  String _formatBillName(String merchantName, BillType type) {
    switch (type) {
      case BillType.phoneRecharge:
        return '$merchantName Mobile';
      case BillType.electricity:
        return '$merchantName Electricity';
      case BillType.internet:
        return '$merchantName Internet';
      case BillType.subscription:
        return '$merchantName Subscription';
      case BillType.creditCard:
        return '$merchantName Bill';
      case BillType.loanEmi:
        return '$merchantName EMI';
      case BillType.rent:
        return 'Rent';
      case BillType.insurance:
        return '$merchantName Premium';
      case BillType.other:
        return merchantName;
    }
  }

  // ====== Reminder Management ======

  /// Start reminder monitoring
  void startReminderMonitoring({Duration checkInterval = const Duration(hours: 6)}) {
    stopReminderMonitoring();

    // Initial check
    _checkUpcomingBills();

    // Periodic checks
    _reminderTimer = Timer.periodic(checkInterval, (_) => _checkUpcomingBills());
  }

  void stopReminderMonitoring() {
    _reminderTimer?.cancel();
    _reminderTimer = null;
  }

  Future<void> _checkUpcomingBills() async {
    final bills = await getActiveBills();
    final now = DateTime.now();

    for (final bill in bills) {
      final daysUntilDue = bill.nextDueDate.difference(now).inDays;

      // Check if within reminder window
      if (daysUntilDue >= 0 && daysUntilDue <= bill.reminderDaysBefore) {
        final alert = BillReminderAlert(
          bill: bill,
          daysUntilDue: daysUntilDue,
          timestamp: now,
        );

        _alertController.add(alert);
        await _sendReminder(alert);
      }

      // Check if overdue
      if (daysUntilDue < 0) {
        final alert = BillReminderAlert(
          bill: bill,
          daysUntilDue: daysUntilDue,
          isOverdue: true,
          timestamp: now,
        );

        _alertController.add(alert);
        await _sendOverdueReminder(alert);
      }
    }
  }

  Future<void> _sendReminder(BillReminderAlert alert) async {
    final daysText = alert.daysUntilDue == 0
        ? 'today'
        : alert.daysUntilDue == 1
            ? 'tomorrow'
            : 'in ${alert.daysUntilDue} days';

    await _notificationService.showBillReminder(
      title: '📅 Bill Due $daysText',
      body: '${alert.bill.name}: ₹${(alert.bill.amountPaisa / 100).toStringAsFixed(0)}',
      payload: {'billId': alert.bill.id},
    );
  }

  Future<void> _sendOverdueReminder(BillReminderAlert alert) async {
    await _notificationService.showBillReminder(
      title: '⚠️ Overdue Bill',
      body: '${alert.bill.name} was due ${(-alert.daysUntilDue)} days ago',
      payload: {'billId': alert.bill.id},
    );
  }

  // ====== CRUD Operations ======

  /// Get all active bills
  Future<List<BillReminder>> getActiveBills() async {
    return _database.billReminderDao.getActive();
  }

  /// Get upcoming bills (next 7 days)
  Future<List<BillReminder>> getUpcomingBills({int days = 7}) async {
    return _database.billReminderDao.getUpcoming(days: days);
  }

  /// Create manual bill reminder
  Future<BillReminder> createBill({
    required String name,
    required int amountPaisa,
    required BillFrequency frequency,
    required DateTime nextDueDate,
    int reminderDaysBefore = 3,
    BillType type = BillType.other,
    String? notes,
  }) async {
    final bill = BillReminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      amountPaisa: amountPaisa,
      frequency: frequency,
      billType: type,
      nextDueDate: nextDueDate,
      reminderDaysBefore: reminderDaysBefore,
      isAutoDetected: false,
      isActive: true,
      notes: notes,
      createdAt: DateTime.now(),
    );

    await _database.billReminderDao.insertBill(bill);

    return bill;
  }

  /// Mark bill as paid
  Future<void> markAsPaid({
    required String billId,
    required int amountPaisa,
    String? transactionId,
  }) async {
    // Record payment
    final payment = BillPayment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      billId: billId,
      amountPaisa: amountPaisa,
      paidAt: DateTime.now(),
      transactionId: transactionId,
      isAutoLinked: transactionId != null,
    );

    await _database.billReminderDao.recordPayment(payment);
  }

  /// Delete bill
  Future<void> deleteBill(String id) async {
    await _database.billReminderDao.deleteBill(id);
  }

  /// Get bills for calendar view
  Future<Map<DateTime, List<BillReminder>>> getBillsCalendar({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final all = await getActiveBills();
    final calendar = <DateTime, List<BillReminder>>{};

    for (final bill in all) {
      // Project due dates within range
      var dueDate = bill.nextDueDate;
      final intervalDays = _getIntervalDays(bill.frequency);

      while (dueDate.isBefore(startDate)) {
        dueDate = dueDate.add(Duration(days: intervalDays));
      }

      while (dueDate.isBefore(endDate)) {
        final dateKey = DateTime(dueDate.year, dueDate.month, dueDate.day);
        calendar.putIfAbsent(dateKey, () => []).add(bill);
        dueDate = dueDate.add(Duration(days: intervalDays));
      }
    }

    return calendar;
  }

  int _getIntervalDays(BillFrequency frequency) {
    switch (frequency) {
      case BillFrequency.weekly: return 7;
      case BillFrequency.biweekly: return 14;
      case BillFrequency.monthly: return 30;
      case BillFrequency.quarterly: return 90;
      case BillFrequency.yearly: return 365;
    }
  }

  void dispose() {
    stopReminderMonitoring();
    _billController.close();
    _alertController.close();
  }
}

// ====== Data Classes ======

enum BillFrequency { weekly, biweekly, monthly, quarterly, yearly }

enum BillType {
  phoneRecharge,
  electricity,
  internet,
  subscription,
  rent,
  creditCard,
  loanEmi,
  insurance,
  other,
}

class BillReminder {
  final String id;
  final String name;
  final String? merchantName;
  final int amountPaisa;
  final BillFrequency frequency;
  final BillType billType;
  final DateTime nextDueDate;
  final int reminderDaysBefore;
  final bool isAutoDetected;
  final bool isActive;
  final String? linkedAccountId;
  final String? notes;
  final List<BillPayment>? paymentHistory;
  final DateTime createdAt;

  const BillReminder({
    required this.id,
    required this.name,
    this.merchantName,
    required this.amountPaisa,
    required this.frequency,
    required this.billType,
    required this.nextDueDate,
    required this.reminderDaysBefore,
    required this.isAutoDetected,
    required this.isActive,
    this.linkedAccountId,
    this.notes,
    this.paymentHistory,
    required this.createdAt,
  });

  /// Is bill due within specified days
  bool isDueSoon({int days = 3}) {
    final now = DateTime.now();
    return nextDueDate.difference(now).inDays <= days && nextDueDate.isAfter(now);
  }

  /// Is bill overdue
  bool get isOverdue => nextDueDate.isBefore(DateTime.now());

  /// Formatted amount
  String get formattedAmount => '₹${(amountPaisa / 100).toStringAsFixed(0)}';

  /// Days until due
  int get daysUntilDue => nextDueDate.difference(DateTime.now()).inDays;
}

class BillPayment {
  final String id;
  final String billId;
  final int amountPaisa;
  final DateTime paidAt;
  final String? transactionId;
  final bool isAutoLinked;

  const BillPayment({
    required this.id,
    required this.billId,
    required this.amountPaisa,
    required this.paidAt,
    this.transactionId,
    required this.isAutoLinked,
  });
}

class BillReminderAlert {
  final BillReminder bill;
  final int daysUntilDue;
  final bool isOverdue;
  final DateTime timestamp;

  const BillReminderAlert({
    required this.bill,
    required this.daysUntilDue,
    this.isOverdue = false,
    required this.timestamp,
  });
}

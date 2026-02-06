import 'dart:async';

import '../../domain/entities/shared_expense.dart' show Friend;
import '../notifications/notification_service.dart';
import '../split/expense_splitting_service.dart' show SimplifiedDebt;

/// SS-105: Settlement Reminder Service
/// Configurable frequency, push notifications, WhatsApp share
class SettlementReminderService {
  final NotificationService _notificationService;
  Timer? _reminderTimer;
  ReminderFrequency _frequency = ReminderFrequency.weekly;
  bool _isEnabled = true;

  SettlementReminderService({
    NotificationService? notificationService,
  }) : _notificationService = notificationService ?? NotificationService.instance;

  /// Set reminder frequency
  void setFrequency(ReminderFrequency frequency) {
    _frequency = frequency;
    _restartTimer();
  }

  /// Enable/disable reminders
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (enabled) {
      _restartTimer();
    } else {
      _reminderTimer?.cancel();
    }
  }

  /// Generate reminders for pending settlements
  List<SettlementReminder> generateReminders({
    required List<SimplifiedDebt> debts,
    required Map<String, Friend> friends,
  }) {
    final reminders = <SettlementReminder>[];

    // Reminders for debts we owe (fromMemberId == 'self')
    for (final debt in debts) {
      if (debt.fromMemberId != 'self') continue;

      final friend = friends[debt.toMemberId];
      if (friend == null) continue;

      final daysOutstanding = _calculateDaysOutstanding(debt);
      
      reminders.add(SettlementReminder(
        debtId: '${debt.fromMemberId}_${debt.toMemberId}',
        friendId: debt.toMemberId,
        friendName: friend.name,
        amountPaisa: debt.amountPaisa,
        daysOutstanding: daysOutstanding,
        phone: friend.phone,
      ));
    }

    return reminders;
  }

  /// Get reminders for friends who owe us
  List<SettlementReminder> getRemindersForOwed({
    required List<SimplifiedDebt> debts,
    required Map<String, Friend> friends,
  }) {
    final reminders = <SettlementReminder>[];

    for (final debt in debts) {
      if (debt.toMemberId != 'self') continue;

      final friend = friends[debt.fromMemberId];
      if (friend == null) continue;

      final daysOutstanding = _calculateDaysOutstanding(debt);

      reminders.add(SettlementReminder(
        debtId: '${debt.fromMemberId}_${debt.toMemberId}',
        friendId: debt.fromMemberId,
        friendName: friend.name,
        amountPaisa: debt.amountPaisa,
        daysOutstanding: daysOutstanding,
        phone: friend.phone,
        isOwedToUs: true,
      ));
    }

    return reminders;
  }

  /// Start periodic reminder checks
  void startPeriodicReminders({
    required List<SettlementReminder> Function() getReminders,
  }) {
    _reminderTimer?.cancel();

    if (!_isEnabled) return;

    Duration interval;
    switch (_frequency) {
      case ReminderFrequency.daily:
        interval = const Duration(days: 1);
        break;
      case ReminderFrequency.weekly:
        interval = const Duration(days: 7);
        break;
      case ReminderFrequency.monthly:
        interval = const Duration(days: 30);
        break;
    }

    _reminderTimer = Timer.periodic(interval, (_) {
      final reminders = getReminders();
      for (final reminder in reminders) {
        _sendReminderNotification(reminder);
      }
    });
  }

  /// Send reminder notification
  Future<void> _sendReminderNotification(SettlementReminder reminder) async {
    final title = reminder.isOwedToUs
        ? '💰 ${reminder.friendName} owes you'
        : '💸 You owe ${reminder.friendName}';
    
    final body = reminder.isOwedToUs
        ? '₹${(reminder.amountPaisa / 100).toStringAsFixed(0)} pending for ${reminder.daysOutstanding} days'
        : '₹${(reminder.amountPaisa / 100).toStringAsFixed(0)} pending for ${reminder.daysOutstanding} days';

    await _notificationService.showBillReminder(
      title: title,
      body: body,
      payload: {
        'type': 'settlement',
        'friendId': reminder.friendId,
        'amountPaisa': reminder.amountPaisa.toString(),
      },
    );
  }

  /// Share reminder via WhatsApp (if phone available)
  Future<bool> shareViaWhatsApp(SettlementReminder reminder) async {
    if (reminder.phone == null) return false;

    // In production, use url_launcher or share_plus package
    // final message = reminder.isOwedToUs
    //     ? 'Hi ${reminder.friendName}, you owe me ₹${(reminder.amountPaisa / 100).toStringAsFixed(0)}. Could you please settle this?'
    //     : 'Hi ${reminder.friendName}, I owe you ₹${(reminder.amountPaisa / 100).toStringAsFixed(0)}. I\'ll settle this soon!';
    // final url = 'https://wa.me/${reminder.phone}?text=${Uri.encodeComponent(message)}';
    // await launchUrl(Uri.parse(url));

    return true;
  }

  int _calculateDaysOutstanding(SimplifiedDebt debt) {
    // Would calculate from first expense date
    // For now, return placeholder
    return 7;
  }

  void _restartTimer() {
    // Will be restarted by startPeriodicReminders
  }

  void dispose() {
    _reminderTimer?.cancel();
  }
}

enum ReminderFrequency { daily, weekly, monthly }

class SettlementReminder {
  final String debtId;
  final String friendId;
  final String friendName;
  final int amountPaisa;
  final int daysOutstanding;
  final String? phone;
  final bool isOwedToUs;

  const SettlementReminder({
    required this.debtId,
    required this.friendId,
    required this.friendName,
    required this.amountPaisa,
    required this.daysOutstanding,
    this.phone,
    this.isOwedToUs = false,
  });
}

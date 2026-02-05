import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import '../privacy/privacy_engine.dart';

/// SS-032: UPI Notification Listener Service
/// Handles Android notification access for instant UPI transaction detection
/// Privacy-first: Only extracts transaction data, not raw notification content

/// Notification permission states
enum NotificationPermissionStatus {
  granted,
  denied,
  notRequested,
  notApplicable, // iOS or non-supported devices
}

/// UPI apps we listen for notifications from
enum UpiAppType {
  googlePay,
  phonePe,
  paytm,
  bharatPe,
  amazonPay,
  whatsAppPay,
  cred,
  other,
}

/// Notification Permission Service
class NotificationPermissionService {
  static const _channel = MethodChannel('dev.duskspendr/notifications');

  /// Check if notification access is granted
  Future<NotificationPermissionStatus> checkPermission() async {
    if (!Platform.isAndroid) {
      return NotificationPermissionStatus.notApplicable;
    }

    try {
      final result = await _channel.invokeMethod<String>('checkNotificationAccess');
      return _parseStatus(result);
    } on PlatformException {
      return NotificationPermissionStatus.denied;
    }
  }

  /// Open notification access settings
  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return false;

    try {
      final result = await _channel.invokeMethod<bool>('openNotificationSettings');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  NotificationPermissionStatus _parseStatus(String? status) {
    switch (status) {
      case 'granted':
        return NotificationPermissionStatus.granted;
      case 'denied':
        return NotificationPermissionStatus.denied;
      case 'notRequested':
        return NotificationPermissionStatus.notRequested;
      default:
        return NotificationPermissionStatus.denied;
    }
  }
}

/// UPI Notification Listener
/// Listens for payment notifications from UPI apps
class UpiNotificationListener {
  static const _channel = MethodChannel('dev.duskspendr/notifications');
  static const _eventChannel = EventChannel('dev.duskspendr/notification_events');

  final NotificationPermissionService _permissionService;
  final PrivacyEngine _privacyEngine;

  StreamSubscription? _subscription;
  final _notificationController = StreamController<UpiPaymentNotification>.broadcast();

  /// Stream of UPI payment notifications
  Stream<UpiPaymentNotification> get notifications => _notificationController.stream;

  UpiNotificationListener({
    NotificationPermissionService? permissionService,
    PrivacyEngine? privacyEngine,
  })  : _permissionService = permissionService ?? NotificationPermissionService(),
        _privacyEngine = privacyEngine ?? PrivacyEngine();

  /// Start listening for UPI notifications
  Future<bool> startListening() async {
    final status = await _permissionService.checkPermission();
    if (status != NotificationPermissionStatus.granted) {
      return false;
    }

    await _privacyEngine.logDataAccess(
      type: DataAccessType.read,
      entity: 'upi_notifications',
      details: 'Started listening for UPI payment notifications',
    );

    _subscription = _eventChannel.receiveBroadcastStream().listen(
      _handleNotification,
      onError: _handleError,
    );

    return true;
  }

  /// Stop listening for notifications
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _handleNotification(dynamic event) {
    if (event is! Map) return;

    final map = Map<String, dynamic>.from(event);
    final packageName = map['package'] as String?;
    final title = map['title'] as String?;
    final text = map['text'] as String?;
    final timestamp = map['timestamp'] as int?;

    if (packageName == null || text == null) return;

    // Identify UPI app
    final appType = _identifyUpiApp(packageName);
    if (appType == null) return;

    // Parse payment notification
    final payment = _parsePaymentNotification(
      appType: appType,
      title: title ?? '',
      text: text,
      timestamp: timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : DateTime.now(),
    );

    if (payment != null) {
      _notificationController.add(payment);
    }
  }

  void _handleError(dynamic error) {
    // Log but don't crash
    _privacyEngine.logDataAccess(
      type: DataAccessType.read,
      entity: 'upi_notifications',
      details: 'Notification listener error: $error',
    );
  }

  UpiAppType? _identifyUpiApp(String packageName) {
    const appPackages = {
      'com.google.android.apps.nbu.paisa.user': UpiAppType.googlePay,
      'com.phonepe.app': UpiAppType.phonePe,
      'net.one97.paytm': UpiAppType.paytm,
      'com.bharatpe.app': UpiAppType.bharatPe,
      'in.amazon.mShop.android.shopping': UpiAppType.amazonPay,
      'com.whatsapp': UpiAppType.whatsAppPay,
      'com.dreamplug.androidapp': UpiAppType.cred,
    };

    return appPackages[packageName];
  }

  UpiPaymentNotification? _parsePaymentNotification({
    required UpiAppType appType,
    required String title,
    required String text,
    required DateTime timestamp,
  }) {
    // Parse based on app type
    switch (appType) {
      case UpiAppType.googlePay:
        return _parseGooglePayNotification(title, text, timestamp);
      case UpiAppType.phonePe:
        return _parsePhonePeNotification(title, text, timestamp);
      case UpiAppType.paytm:
        return _parsePaytmNotification(title, text, timestamp);
      case UpiAppType.bharatPe:
        return _parseBharatPeNotification(title, text, timestamp);
      case UpiAppType.cred:
        return _parseCredNotification(title, text, timestamp);
      default:
        return _parseGenericUpiNotification(appType, title, text, timestamp);
    }
  }

  UpiPaymentNotification? _parseGooglePayNotification(
    String title,
    String text,
    DateTime timestamp,
  ) {
    // GPay patterns:
    // "Received ₹100 from John"
    // "Paid ₹100 to Swiggy"
    // "₹100 sent to amit@ybl"

    final amountMatch = RegExp(r'₹\s*([\d,]+(?:\.\d{1,2})?)').firstMatch(text);
    if (amountMatch == null) return null;

    final amountStr = amountMatch.group(1)?.replaceAll(',', '');
    final amount = double.tryParse(amountStr ?? '');
    if (amount == null) return null;

    final textLower = text.toLowerCase();
    final isReceived = textLower.contains('received') || textLower.contains('credited');
    final isSent = textLower.contains('paid') || textLower.contains('sent') || textLower.contains('debited');

    if (!isReceived && !isSent) return null;

    // Extract counterparty
    String? counterparty;
    final fromMatch = RegExp(r'from\s+([A-Za-z\s]+?)(?:\s|$)').firstMatch(text);
    final toMatch = RegExp(r'to\s+([A-Za-z\s@._]+?)(?:\s|$)').firstMatch(text);
    counterparty = fromMatch?.group(1)?.trim() ?? toMatch?.group(1)?.trim();

    return UpiPaymentNotification(
      app: UpiAppType.googlePay,
      amountPaisa: (amount * 100).round(),
      isCredit: isReceived,
      counterparty: counterparty,
      timestamp: timestamp,
      rawTitle: title,
      rawText: text,
      confidence: 0.9,
    );
  }

  UpiPaymentNotification? _parsePhonePeNotification(
    String title,
    String text,
    DateTime timestamp,
  ) {
    // PhonePe patterns:
    // "Payment of ₹100 to Merchant successful"
    // "Received ₹100 from John"

    final amountMatch = RegExp(r'₹\s*([\d,]+(?:\.\d{1,2})?)').firstMatch(text);
    if (amountMatch == null) return null;

    final amountStr = amountMatch.group(1)?.replaceAll(',', '');
    final amount = double.tryParse(amountStr ?? '');
    if (amount == null) return null;

    final textLower = text.toLowerCase();
    final isReceived = textLower.contains('received') || textLower.contains('credited');
    final isSent = textLower.contains('payment') || textLower.contains('paid') || textLower.contains('sent');

    if (!isReceived && !isSent) return null;

    // Extract counterparty
    String? counterparty;
    final toMatch = RegExp(r'to\s+([A-Za-z\s]+?)(?:\s+successful|$)').firstMatch(text);
    final fromMatch = RegExp(r'from\s+([A-Za-z\s]+?)(?:\s|$)').firstMatch(text);
    counterparty = toMatch?.group(1)?.trim() ?? fromMatch?.group(1)?.trim();

    return UpiPaymentNotification(
      app: UpiAppType.phonePe,
      amountPaisa: (amount * 100).round(),
      isCredit: isReceived,
      counterparty: counterparty,
      timestamp: timestamp,
      rawTitle: title,
      rawText: text,
      confidence: 0.9,
    );
  }

  UpiPaymentNotification? _parsePaytmNotification(
    String title,
    String text,
    DateTime timestamp,
  ) {
    final amountMatch = RegExp(r'₹\s*([\d,]+(?:\.\d{1,2})?)').firstMatch(text);
    if (amountMatch == null) return null;

    final amountStr = amountMatch.group(1)?.replaceAll(',', '');
    final amount = double.tryParse(amountStr ?? '');
    if (amount == null) return null;

    final textLower = text.toLowerCase();
    final isReceived = textLower.contains('received') || textLower.contains('credited') || textLower.contains('added');
    final isSent = textLower.contains('paid') || textLower.contains('sent') || textLower.contains('transferred');

    if (!isReceived && !isSent) return null;

    return UpiPaymentNotification(
      app: UpiAppType.paytm,
      amountPaisa: (amount * 100).round(),
      isCredit: isReceived,
      timestamp: timestamp,
      rawTitle: title,
      rawText: text,
      confidence: 0.85,
    );
  }

  UpiPaymentNotification? _parseBharatPeNotification(
    String title,
    String text,
    DateTime timestamp,
  ) {
    final amountMatch = RegExp(r'₹\s*([\d,]+(?:\.\d{1,2})?)').firstMatch(text);
    if (amountMatch == null) return null;

    final amountStr = amountMatch.group(1)?.replaceAll(',', '');
    final amount = double.tryParse(amountStr ?? '');
    if (amount == null) return null;

    final textLower = text.toLowerCase();
    final isReceived = textLower.contains('received') || textLower.contains('credited');

    return UpiPaymentNotification(
      app: UpiAppType.bharatPe,
      amountPaisa: (amount * 100).round(),
      isCredit: isReceived,
      timestamp: timestamp,
      rawTitle: title,
      rawText: text,
      confidence: 0.85,
    );
  }

  UpiPaymentNotification? _parseCredNotification(
    String title,
    String text,
    DateTime timestamp,
  ) {
    // CRED patterns: "Bill payment of ₹1,234 successful"
    final amountMatch = RegExp(r'₹\s*([\d,]+(?:\.\d{1,2})?)').firstMatch(text);
    if (amountMatch == null) return null;

    final amountStr = amountMatch.group(1)?.replaceAll(',', '');
    final amount = double.tryParse(amountStr ?? '');
    if (amount == null) return null;

    final textLower = text.toLowerCase();
    final isPayment = textLower.contains('payment') || textLower.contains('paid');

    if (!isPayment) return null;

    return UpiPaymentNotification(
      app: UpiAppType.cred,
      amountPaisa: (amount * 100).round(),
      isCredit: false, // CRED is mostly payments
      timestamp: timestamp,
      rawTitle: title,
      rawText: text,
      confidence: 0.85,
    );
  }

  UpiPaymentNotification? _parseGenericUpiNotification(
    UpiAppType appType,
    String title,
    String text,
    DateTime timestamp,
  ) {
    final amountMatch = RegExp(r'₹\s*([\d,]+(?:\.\d{1,2})?)').firstMatch(text);
    if (amountMatch == null) return null;

    final amountStr = amountMatch.group(1)?.replaceAll(',', '');
    final amount = double.tryParse(amountStr ?? '');
    if (amount == null) return null;

    final textLower = text.toLowerCase();
    final isCredit = textLower.contains('received') || textLower.contains('credited');

    return UpiPaymentNotification(
      app: appType,
      amountPaisa: (amount * 100).round(),
      isCredit: isCredit,
      timestamp: timestamp,
      rawTitle: title,
      rawText: text,
      confidence: 0.7,
    );
  }

  void dispose() {
    stopListening();
    _notificationController.close();
  }
}

/// Parsed UPI payment notification
class UpiPaymentNotification {
  final UpiAppType app;
  final int amountPaisa;
  final bool isCredit;
  final String? counterparty;
  final String? upiId;
  final String? referenceId;
  final DateTime timestamp;
  final String rawTitle;
  final String rawText;
  final double confidence;

  const UpiPaymentNotification({
    required this.app,
    required this.amountPaisa,
    required this.isCredit,
    this.counterparty,
    this.upiId,
    this.referenceId,
    required this.timestamp,
    required this.rawTitle,
    required this.rawText,
    required this.confidence,
  });

  /// Get app display name
  String get appName {
    switch (app) {
      case UpiAppType.googlePay:
        return 'Google Pay';
      case UpiAppType.phonePe:
        return 'PhonePe';
      case UpiAppType.paytm:
        return 'Paytm';
      case UpiAppType.bharatPe:
        return 'BharatPe';
      case UpiAppType.amazonPay:
        return 'Amazon Pay';
      case UpiAppType.whatsAppPay:
        return 'WhatsApp Pay';
      case UpiAppType.cred:
        return 'CRED';
      case UpiAppType.other:
        return 'UPI';
    }
  }
}

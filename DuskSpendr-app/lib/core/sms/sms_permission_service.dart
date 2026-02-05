import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'sms_parser.dart';

/// SS-033: SMS Permission & Reader Service
/// Handles SMS permission requests and inbox reading on Android
/// 100% on-device processing - raw SMS never leaves device

/// SMS permission states
enum SmsPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  notApplicable, // iOS doesn't support SMS reading
}

/// SMS Permission Service
class SmsPermissionService {
  static const _channel = MethodChannel('dev.duskspendr/sms');

  /// Check current SMS permission status
  Future<SmsPermissionStatus> checkPermission() async {
    if (!Platform.isAndroid) {
      return SmsPermissionStatus.notApplicable;
    }

    try {
      final result = await _channel.invokeMethod<String>('checkSmsPermission');
      return _parsePermissionStatus(result);
    } on PlatformException {
      return SmsPermissionStatus.denied;
    }
  }

  /// Request SMS read permission
  Future<SmsPermissionStatus> requestPermission() async {
    if (!Platform.isAndroid) {
      return SmsPermissionStatus.notApplicable;
    }

    try {
      final result = await _channel.invokeMethod<String>('requestSmsPermission');
      return _parsePermissionStatus(result);
    } on PlatformException {
      return SmsPermissionStatus.denied;
    }
  }

  /// Check if we can read SMS (permission granted + Android)
  Future<bool> canReadSms() async {
    final status = await checkPermission();
    return status == SmsPermissionStatus.granted;
  }

  /// Open app settings for manual permission grant
  Future<bool> openAppSettings() async {
    if (!Platform.isAndroid) return false;

    try {
      final result = await _channel.invokeMethod<bool>('openAppSettings');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  SmsPermissionStatus _parsePermissionStatus(String? status) {
    switch (status) {
      case 'granted':
        return SmsPermissionStatus.granted;
      case 'denied':
        return SmsPermissionStatus.denied;
      case 'permanentlyDenied':
        return SmsPermissionStatus.permanentlyDenied;
      default:
        return SmsPermissionStatus.denied;
    }
  }
}

/// SMS Inbox Reader Service
/// Reads SMS messages from device inbox for financial transaction detection
class SmsInboxReader {
  static const _channel = MethodChannel('dev.duskspendr/sms');
  final SmsPermissionService _permissionService;

  SmsInboxReader({SmsPermissionService? permissionService})
      : _permissionService = permissionService ?? SmsPermissionService();

  /// Read SMS messages from inbox
  /// [since] - Only read messages after this timestamp
  /// [senderFilter] - Regex pattern to filter senders (e.g., bank IDs)
  Future<SmsReadResult> readMessages({
    DateTime? since,
    String? senderFilter,
    int maxCount = 100,
  }) async {
    // Check permission first
    final canRead = await _permissionService.canReadSms();
    if (!canRead) {
      return SmsReadResult.permissionDenied();
    }

    try {
      final result = await _channel.invokeMethod<List>('readSmsInbox', {
        'since': since?.millisecondsSinceEpoch,
        'senderFilter': senderFilter,
        'maxCount': maxCount,
      });

      if (result == null) {
        return SmsReadResult.success([]);
      }

      final messages = result.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return RawSmsMessage(
          id: map['id'] as String,
          sender: map['sender'] as String,
          body: map['body'] as String,
          timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
          isRead: map['isRead'] as bool? ?? true,
        );
      }).toList();

      return SmsReadResult.success(messages);
    } on PlatformException catch (e) {
      return SmsReadResult.error(e.message ?? 'Failed to read SMS');
    }
  }

  /// Read only financial SMS messages (from known bank senders)
  Future<SmsReadResult> readFinancialMessages({
    DateTime? since,
    int maxCount = 100,
  }) async {
    // Filter for common financial sender patterns
    const financialSenderPattern =
        r'^((?:AD-|AX-|BM-|BT-|DM-|HP-|IM-|JD-|MD-|ND-|SA-|TM-|VM-|VK-)?'
        r'(?:SBI|HDFC|ICICI|AXIS|KOTAK|PNB|BOB|BOI|CANARA|UNION|YES|IDFC|'
        r'IDBI|PAYTM|PHONEPE|GPAY|AMAZON|UBER|SWIGGY|ZOMATO|FLIPKART|'
        r'CRED|BHARATPE|FREECHARGE|MOBIKWIK|SIMPL|LAZYPAY|SLICE)\w*)';

    return readMessages(
      since: since,
      senderFilter: financialSenderPattern,
      maxCount: maxCount,
    );
  }

  /// Get count of unprocessed financial SMS
  Future<int> getUnprocessedCount({DateTime? since}) async {
    final canRead = await _permissionService.canReadSms();
    if (!canRead) return 0;

    try {
      final count = await _channel.invokeMethod<int>('getFinancialSmsCount', {
        'since': since?.millisecondsSinceEpoch,
      });
      return count ?? 0;
    } on PlatformException {
      return 0;
    }
  }
}

/// Raw SMS message from inbox
class RawSmsMessage {
  final String id;
  final String sender;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  const RawSmsMessage({
    required this.id,
    required this.sender,
    required this.body,
    required this.timestamp,
    required this.isRead,
  });

  /// Convert to RawSms for parser
  RawSms toRawSms() => RawSms(
        sender: sender,
        body: body,
        timestamp: timestamp,
      );
}

/// Result of SMS reading operation
class SmsReadResult {
  final bool success;
  final List<RawSmsMessage> messages;
  final String? error;
  final bool permissionRequired;

  const SmsReadResult({
    required this.success,
    this.messages = const [],
    this.error,
    this.permissionRequired = false,
  });

  factory SmsReadResult.success(List<RawSmsMessage> messages) => SmsReadResult(
        success: true,
        messages: messages,
      );

  factory SmsReadResult.error(String error) => SmsReadResult(
        success: false,
        error: error,
      );

  factory SmsReadResult.permissionDenied() => const SmsReadResult(
        success: false,
        error: 'SMS permission not granted',
        permissionRequired: true,
      );
}


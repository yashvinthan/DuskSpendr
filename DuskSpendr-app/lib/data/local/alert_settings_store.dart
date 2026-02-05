import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AlertSettingsStore {
  static const _key = 'budget_alert_settings_v1';

  final FlutterSecureStorage _storage;

  AlertSettingsStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<BudgetAlertSettings?> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;
    return BudgetAlertSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> write(BudgetAlertSettings settings) async {
    await _storage.write(key: _key, value: jsonEncode(settings.toJson()));
  }
}

class BudgetAlertSettings {
  const BudgetAlertSettings({
    required this.alert50,
    required this.alert80,
    required this.alert100,
    required this.predictiveAlerts,
    required this.dailySummary,
    required this.quietHoursStart,
    required this.quietHoursEnd,
  });

  final bool alert50;
  final bool alert80;
  final bool alert100;
  final bool predictiveAlerts;
  final bool dailySummary;
  final int quietHoursStart;
  final int quietHoursEnd;

  BudgetAlertSettings copyWith({
    bool? alert50,
    bool? alert80,
    bool? alert100,
    bool? predictiveAlerts,
    bool? dailySummary,
    int? quietHoursStart,
    int? quietHoursEnd,
  }) {
    return BudgetAlertSettings(
      alert50: alert50 ?? this.alert50,
      alert80: alert80 ?? this.alert80,
      alert100: alert100 ?? this.alert100,
      predictiveAlerts: predictiveAlerts ?? this.predictiveAlerts,
      dailySummary: dailySummary ?? this.dailySummary,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alert50': alert50,
      'alert80': alert80,
      'alert100': alert100,
      'predictiveAlerts': predictiveAlerts,
      'dailySummary': dailySummary,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
    };
  }

  factory BudgetAlertSettings.fromJson(Map<String, dynamic> json) {
    return BudgetAlertSettings(
      alert50: json['alert50'] as bool? ?? true,
      alert80: json['alert80'] as bool? ?? true,
      alert100: json['alert100'] as bool? ?? true,
      predictiveAlerts: json['predictiveAlerts'] as bool? ?? true,
      dailySummary: json['dailySummary'] as bool? ?? false,
      quietHoursStart: json['quietHoursStart'] as int? ?? 22,
      quietHoursEnd: json['quietHoursEnd'] as int? ?? 8,
    );
  }

  static const defaults = BudgetAlertSettings(
    alert50: true,
    alert80: true,
    alert100: true,
    predictiveAlerts: true,
    dailySummary: false,
    quietHoursStart: 22,
    quietHoursEnd: 8,
  );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/alert_settings_store.dart';

final alertSettingsStoreProvider = Provider<AlertSettingsStore>((ref) {
  return AlertSettingsStore();
});

final alertSettingsProvider =
    StateNotifierProvider<AlertSettingsNotifier, BudgetAlertSettings>((ref) {
  return AlertSettingsNotifier(ref.watch(alertSettingsStoreProvider));
});

class AlertSettingsNotifier extends StateNotifier<BudgetAlertSettings> {
  AlertSettingsNotifier(this._store) : super(BudgetAlertSettings.defaults) {
    _load();
  }

  final AlertSettingsStore _store;

  Future<void> _load() async {
    final stored = await _store.read();
    if (stored != null) {
      state = stored;
    }
  }

  Future<void> update(BudgetAlertSettings settings) async {
    state = settings;
    await _store.write(settings);
  }
}

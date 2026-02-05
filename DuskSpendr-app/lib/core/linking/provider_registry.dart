import '../linking/account_linker.dart';
import '../linking/provider_features.dart';
import '../linking/providers/bank_linkers.dart';
import '../linking/providers/upi_linkers.dart';
import '../linking/providers/wallet_bnpl_linkers.dart';
import '../linking/providers/investment_linkers.dart';

/// Provider Registry for Account Linking
/// Centralizes provider management, discovery, and lifecycle
class ProviderRegistry {
  static final ProviderRegistry _instance = ProviderRegistry._internal();
  factory ProviderRegistry() => _instance;
  ProviderRegistry._internal();

  final Map<AccountProviderType, AccountLinker> _providers = {};
  final Map<AccountProviderType, ProviderHealth> _health = {};
  
  bool _initialized = false;

  /// Initialize the registry with all supported providers
  Future<void> initialize() async {
    if (_initialized) return;

    // Register bank providers
    _maybeRegister(AccountProviderType.sbi, SbiBankLinker());
    _maybeRegister(AccountProviderType.hdfc, HdfcBankLinker());
    _maybeRegister(AccountProviderType.icici, IciciBankLinker());
    _maybeRegister(AccountProviderType.axis, AxisBankLinker());

    // Register UPI providers
    _maybeRegister(AccountProviderType.gpay, GpayLinker());
    _maybeRegister(AccountProviderType.phonepe, PhonepeLinker());
    _maybeRegister(AccountProviderType.paytmUpi, PaytmUpiLinker());

    // Register wallet/BNPL providers
    _maybeRegister(AccountProviderType.amazonPay, AmazonPayLinker());
    _maybeRegister(AccountProviderType.paytmWallet, PaytmWalletLinker());
    _maybeRegister(AccountProviderType.lazypay, LazypayLinker());
    _maybeRegister(AccountProviderType.simpl, SimplLinker());
    _maybeRegister(AccountProviderType.amazonPayLater, AmazonPayLaterLinker());

    // Register investment providers
    _maybeRegister(AccountProviderType.zerodha, ZerodhaLinker());
    _maybeRegister(AccountProviderType.groww, GrowwLinker());
    _maybeRegister(AccountProviderType.upstox, UpstoxLinker());
    _maybeRegister(AccountProviderType.angelOne, AngelOneLinker());
    _maybeRegister(AccountProviderType.zerodhaCoins, ZerodhaCoinsLinker());
    _maybeRegister(AccountProviderType.indmoney, IndmoneyLinker());

    _initialized = true;
  }

  void _registerProvider(AccountProviderType type, AccountLinker linker) {
    _providers[type] = linker;
    _health[type] = ProviderHealth(
      type: type,
      status: ProviderStatus.available,
      lastChecked: DateTime.now(),
    );
  }

  void _maybeRegister(AccountProviderType type, AccountLinker linker) {
    if (!ProviderFeatureFlags.isEnabled(type)) {
      return;
    }
    _registerProvider(type, linker);
  }

  // ====== Provider Access ======

  /// Get a specific provider linker
  AccountLinker? getProvider(AccountProviderType type) {
    _ensureInitialized();
    return _providers[type];
  }

  /// Get all registered providers
  List<AccountProviderType> get allProviders {
    _ensureInitialized();
    return _providers.keys.toList();
  }

  /// Get providers by category
  List<AccountProviderType> getProvidersByCategory(ProviderCategory category) {
    _ensureInitialized();
    return _providers.keys
        .where((type) => type.category == category)
        .toList();
  }

  /// Get available (healthy) providers
  List<AccountProviderType> get availableProviders {
    _ensureInitialized();
    return _health.entries
        .where((e) => e.value.status == ProviderStatus.available)
        .map((e) => e.key)
        .toList();
  }

  /// Check if a provider is supported
  bool isSupported(AccountProviderType type) {
    _ensureInitialized();
    return _providers.containsKey(type);
  }

  /// Check if a provider is available (supported and healthy)
  bool isAvailable(AccountProviderType type) {
    _ensureInitialized();
    final health = _health[type];
    return health != null && health.status == ProviderStatus.available;
  }

  // ====== Health Management ======

  /// Get health status for a provider
  ProviderHealth? getHealth(AccountProviderType type) {
    return _health[type];
  }

  /// Update provider health status
  void updateHealth(
    AccountProviderType type, {
    required ProviderStatus status,
    String? message,
    DateTime? nextRetry,
  }) {
    final current = _health[type];
    if (current == null) return;

    _health[type] = ProviderHealth(
      type: type,
      status: status,
      lastChecked: DateTime.now(),
      message: message,
      nextRetry: nextRetry,
      consecutiveFailures: status == ProviderStatus.available
          ? 0
          : current.consecutiveFailures + 1,
    );
  }

  /// Record a successful operation
  void recordSuccess(AccountProviderType type) {
    updateHealth(type, status: ProviderStatus.available);
  }

  /// Record a failed operation
  void recordFailure(AccountProviderType type, String error) {
    final current = _health[type];
    final failures = (current?.consecutiveFailures ?? 0) + 1;

    // Progressive backoff
    final status = failures >= 5
        ? ProviderStatus.unavailable
        : ProviderStatus.degraded;

    final backoffMinutes = _calculateBackoff(failures);
    
    updateHealth(
      type,
      status: status,
      message: error,
      nextRetry: DateTime.now().add(Duration(minutes: backoffMinutes)),
    );
  }

  int _calculateBackoff(int failures) {
    // Exponential backoff: 1, 2, 4, 8, 15, 30 minutes
    return switch (failures) {
      1 => 1,
      2 => 2,
      3 => 4,
      4 => 8,
      5 => 15,
      _ => 30,
    };
  }

  /// Check all providers' health
  Future<Map<AccountProviderType, ProviderHealth>> checkAllHealth() async {
    _ensureInitialized();
    // In production, would ping each provider's status endpoint
    return Map.from(_health);
  }

  // ====== Provider Discovery ======

  /// Get provider info for UI display
  List<ProviderInfo> getProvidersForDisplay({ProviderCategory? category}) {
    _ensureInitialized();
    
    return _providers.entries
        .where((e) => category == null || e.key.category == category)
        .map((e) {
          final health = _health[e.key];
          return ProviderInfo(
            type: e.key,
            displayName: e.value.displayName,
            iconPath: e.value.iconPath,
            category: e.key.category,
            supportsRealTimeSync: e.value.supportsRealTimeSync,
            isAvailable: health?.status == ProviderStatus.available,
            statusMessage: health?.message,
          );
        })
        .toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));
  }

  /// Get suggested providers for a user
  List<ProviderInfo> getSuggestedProviders() {
    // Return most popular providers for Indian students
    final suggested = [
      AccountProviderType.gpay,
      AccountProviderType.phonepe,
      AccountProviderType.paytmUpi,
      AccountProviderType.groww,
      AccountProviderType.lazypay,
    ];

    return suggested
        .where((type) => isAvailable(type))
        .map((type) {
          final linker = _providers[type]!;
          return ProviderInfo(
            type: type,
            displayName: linker.displayName,
            iconPath: linker.iconPath,
            category: type.category,
            supportsRealTimeSync: linker.supportsRealTimeSync,
            isAvailable: true,
          );
        })
        .toList();
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('ProviderRegistry not initialized. Call initialize() first.');
    }
  }

  /// Reset for testing
  void reset() {
    _providers.clear();
    _health.clear();
    _initialized = false;
  }
}

// ====== Health Models ======

enum ProviderStatus {
  available,   // Working normally
  degraded,    // Working but with issues
  unavailable, // Not working
  maintenance, // Scheduled maintenance
}

class ProviderHealth {
  final AccountProviderType type;
  final ProviderStatus status;
  final DateTime lastChecked;
  final String? message;
  final DateTime? nextRetry;
  final int consecutiveFailures;

  const ProviderHealth({
    required this.type,
    required this.status,
    required this.lastChecked,
    this.message,
    this.nextRetry,
    this.consecutiveFailures = 0,
  });

  bool get canRetry {
    if (status == ProviderStatus.available) return true;
    if (nextRetry == null) return true;
    return DateTime.now().isAfter(nextRetry!);
  }
}

class ProviderInfo {
  final AccountProviderType type;
  final String displayName;
  final String iconPath;
  final ProviderCategory category;
  final bool supportsRealTimeSync;
  final bool isAvailable;
  final String? statusMessage;

  const ProviderInfo({
    required this.type,
    required this.displayName,
    required this.iconPath,
    required this.category,
    required this.supportsRealTimeSync,
    required this.isAvailable,
    this.statusMessage,
  });
}

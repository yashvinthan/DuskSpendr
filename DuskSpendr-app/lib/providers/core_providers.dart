import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/linking/linking.dart';
import '../core/privacy/privacy.dart';
import '../core/sync/sync.dart';
import 'database_provider.dart';
import 'feature_providers.dart' as feature;
import '../data/local/privacy_store_drift.dart';

// ====== Privacy & Audit Providers ======

/// Privacy Engine provider
final privacyEngineProvider = Provider<PrivacyEngine>((ref) {
  final auditDao = ref.watch(auditLogDaoProvider);
  final reportDao = ref.watch(privacyReportDaoProvider);
  final store = DriftPrivacyStore(
    auditLogDao: auditDao,
    privacyReportDao: reportDao,
  );
  return PrivacyEngine(store: store);
});

/// Audit Trail Service provider (database-backed)
final auditTrailProvider = Provider<AuditTrailService>((ref) {
  final database = ref.watch(databaseProvider);
  return AuditTrailService(database);
});

/// Recent audit summary provider
final auditSummaryProvider = FutureProvider<AuditSummary>((ref) async {
  final auditService = ref.watch(auditTrailProvider);
  return auditService.getRecentSummary(days: 7);
});

// ====== Account Linking Providers ======

/// Provider Registry (singleton)
final providerRegistryProvider = Provider<ProviderRegistry>((ref) {
  final registry = ProviderRegistry();
  // Initialize on first access
  registry.initialize();
  return registry;
});

/// Secure Token Manager provider
final tokenManagerProvider = Provider<SecureTokenManager>((ref) {
  final privacy = ref.watch(privacyEngineProvider);
  return SecureTokenManager(privacyEngine: privacy);
});

/// Available providers for linking
final availableProvidersProvider = Provider<List<ProviderInfo>>((ref) {
  final registry = ref.watch(providerRegistryProvider);
  return registry.getProvidersForDisplay();
});

/// Providers grouped by category
final providersByCategoryProvider = Provider.family<List<ProviderInfo>, ProviderCategory>(
  (ref, category) {
    final registry = ref.watch(providerRegistryProvider);
    return registry.getProvidersForDisplay(category: category);
  },
);

/// Suggested providers for user
final suggestedProvidersProvider = Provider<List<ProviderInfo>>((ref) {
  final registry = ref.watch(providerRegistryProvider);
  return registry.getSuggestedProviders();
});

// ====== Sync Pipeline Providers ======

/// Sync Pipeline provider
final syncPipelineProvider = Provider<SyncPipeline>((ref) {
  final privacy = ref.watch(privacyEngineProvider);
  return SyncPipeline(privacyEngine: privacy);
});

/// Data Synchronizer provider
final dataSynchronizerProvider = Provider<DataSynchronizer>((ref) {
  final privacy = ref.watch(privacyEngineProvider);
  return DataSynchronizer(
    privacyEngine: privacy,
    linkingManager: ref.watch(feature.accountLinkingManagerProvider),
    transactionDao: ref.watch(transactionDaoProvider),
    accountDao: ref.watch(accountDaoProvider),
    categorizer: ref.watch(feature.transactionCategorizerProvider),
  );
});

/// Sync status stream provider
final syncStatusStreamProvider = StreamProvider<SyncStatus>((ref) {
  final synchronizer = ref.watch(dataSynchronizerProvider);
  return synchronizer.syncStatusStream;
});

/// Current sync state provider
final syncStateProvider = StateProvider<SyncState>((ref) {
  return SyncState.idle;
});

// ====== Combined Providers ======

/// Core services bundle for easy access
final coreServicesProvider = Provider<CoreServices>((ref) {
  return CoreServices(
    privacy: ref.watch(privacyEngineProvider),
    auditTrail: ref.watch(auditTrailProvider),
    tokenManager: ref.watch(tokenManagerProvider),
    providerRegistry: ref.watch(providerRegistryProvider),
    syncPipeline: ref.watch(syncPipelineProvider),
  );
});

class CoreServices {
  final PrivacyEngine privacy;
  final AuditTrailService auditTrail;
  final SecureTokenManager tokenManager;
  final ProviderRegistry providerRegistry;
  final SyncPipeline syncPipeline;

  const CoreServices({
    required this.privacy,
    required this.auditTrail,
    required this.tokenManager,
    required this.providerRegistry,
    required this.syncPipeline,
  });
}

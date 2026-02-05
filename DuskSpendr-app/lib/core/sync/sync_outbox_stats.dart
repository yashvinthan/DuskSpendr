class SyncOutboxStats {
  final int pending;
  final int syncing;
  final int failed;
  final int succeeded;

  const SyncOutboxStats({
    required this.pending,
    required this.syncing,
    required this.failed,
    required this.succeeded,
  });

  int get total => pending + syncing + failed + succeeded;
}

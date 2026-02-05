import 'package:serverpod/serverpod.dart';

import '../lib/src/generated/endpoints.dart';
import '../lib/src/generated/protocol.dart';
import '../lib/src/web/sync_router.dart';

void main(List<String> args) {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );
  pod.webServer.addHandler((request) => handleSyncRequests(request, pod));
  pod.start();
}

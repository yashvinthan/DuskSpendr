import 'package:serverpod/serverpod.dart';

class HealthEndpoint extends Endpoint {
  Future<String> ping(Session session) async {
    return 'ok';
  }
}

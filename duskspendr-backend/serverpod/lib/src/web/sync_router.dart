import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import 'db.dart';

class SyncRoute extends Route {
  SyncRoute() : super(method: RouteMethod.post);

  @override
  void setHeaders(HttpHeaders headers) {
    headers.contentType = ContentType('application', 'json', charset: 'utf-8');
  }

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    if (request.method.toUpperCase() != 'POST') {
      request.response.statusCode = HttpStatus.methodNotAllowed;
      request.response.write(jsonEncode({'error': 'method not allowed'}));
      return true;
    }

    final userId = request.headers.value('x-user-id');
    if (userId == null || userId.isEmpty) {
      request.response.statusCode = HttpStatus.badRequest;
      request.response.write(jsonEncode({'error': 'missing user id'}));
      return true;
    }

    final syncSecret = Platform.environment['SYNC_SHARED_SECRET'];
    if (syncSecret == null || syncSecret.isEmpty) {
      request.response.statusCode = HttpStatus.internalServerError;
      request.response
          .write(jsonEncode({'error': 'sync secret not configured'}));
      return true;
    }

    final timestamp = request.headers.value('x-sync-timestamp');
    final signature = request.headers.value('x-sync-signature');
    if (timestamp == null || signature == null) {
      request.response.statusCode = HttpStatus.unauthorized;
      request.response.write(jsonEncode({'error': 'missing sync signature'}));
      return true;
    }

    final body = await utf8.decoder.bind(request).join();
    final payload = body.isEmpty ? '{}' : body;

    if (!_isValidSignature(syncSecret, timestamp, userId, payload, signature)) {
      request.response.statusCode = HttpStatus.unauthorized;
      request.response.write(jsonEncode({'error': 'invalid sync signature'}));
      return true;
    }

    final dbUrl = Platform.environment['SERVERPOD_DB_URL'] ??
        Platform.environment['DATABASE_URL'];
    if (dbUrl == null || dbUrl.isEmpty) {
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write(jsonEncode({'error': 'db url not configured'}));
      return true;
    }

    final db = await SyncDb.connect(dbUrl);
    try {
      await db.insertSync(userId, payload);
    } finally {
      await db.close();
    }

    request.response.write(jsonEncode({'status': 'stored'}));
    return true;
  }
}

bool _isValidSignature(
  String secret,
  String timestamp,
  String userId,
  String payload,
  String signature,
) {
  final ts = int.tryParse(timestamp);
  if (ts == null) return false;
  final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  if ((now - ts).abs() > 300) return false;

  final message = '$timestamp.$userId.$payload';
  final hmac = Hmac(sha256, utf8.encode(secret));
  final digest = hmac.convert(utf8.encode(message));
  final expected = base64UrlEncode(digest.bytes).replaceAll('=', '');
  return _constantTimeEquals(expected, signature);
}

bool _constantTimeEquals(String a, String b) {
  if (a.length != b.length) return false;
  var result = 0;
  for (var i = 0; i < a.length; i++) {
    result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return result == 0;
}

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import 'package:serverpod/serverpod.dart';

import 'db.dart';

Future<Response> handleSyncRequests(Request request, Serverpod pod) async {
  if (request.url.path != 'sync/transactions') {
    return Response.notFound('Not found');
  }
  final userId = request.headers['x-user-id'];
  if (userId == null || userId.isEmpty) {
    return Response.json({'error': 'missing user id'}, status: 400);
  }
  final syncSecret = Platform.environment['SYNC_SHARED_SECRET'];
  if (syncSecret == null || syncSecret.isEmpty) {
    return Response.json({'error': 'sync secret not configured'}, status: 500);
  }
  final timestamp = request.headers['x-sync-timestamp'];
  final signature = request.headers['x-sync-signature'];
  if (timestamp == null || signature == null) {
    return Response.json({'error': 'missing sync signature'}, status: 401);
  }
  final body = await request.readAsString();
  final payload = body.isEmpty ? '{}' : body;

  if (!_isValidSignature(syncSecret, timestamp, userId, payload, signature)) {
    return Response.json({'error': 'invalid sync signature'}, status: 401);
  }

  final dbUrl = Platform.environment['SERVERPOD_DB_URL'] ??
      Platform.environment['DATABASE_URL'];
  if (dbUrl == null || dbUrl.isEmpty) {
    return Response.json({'error': 'db url not configured'}, status: 500);
  }
  final db = await SyncDb.connect(dbUrl);
  try {
    await db.insertSync(userId, payload);
  } finally {
    await db.close();
  }

  return Response.json({'status': 'stored'});
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

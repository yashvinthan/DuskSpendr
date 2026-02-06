import 'dart:convert';

import 'package:http/http.dart' as http;

/// HTTP client for API calls. Never log request/response bodies that may contain tokens.
class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? client,
    void Function()? onUnauthorized,
  })  : _client = client ?? http.Client(),
        _onUnauthorized = onUnauthorized;

  final String baseUrl;
  final http.Client _client;
  final void Function()? _onUnauthorized;

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body ?? {}),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.get(uri, headers: headers);
    return _decode(response);
  }

  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body ?? {}),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> deleteJson(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.delete(uri, headers: headers);
    return _decode(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode == 401) {
      _onUnauthorized?.call();
    }
    Map<String, dynamic> payload = {};
    if (response.body.isNotEmpty) {
      try {
        payload = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        // ignore invalid JSON on error responses
      }
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return payload;
    }
    final message = payload['error']?.toString() ?? 'Request failed';
    throw ApiException(message, response.statusCode);
  }
}

class ApiException implements Exception {
  ApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;
}

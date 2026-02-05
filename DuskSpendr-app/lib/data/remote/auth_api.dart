import 'api_client.dart';

class AuthApi {
  AuthApi(this._client);

  final ApiClient _client;

  Future<AuthStartResponse> startOtp(String phone) async {
    final res = await _client.postJson('/v1/auth/start', body: {
      'phone': phone,
    });
    return AuthStartResponse.fromJson(res);
  }

  Future<AuthVerifyResponse> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final res = await _client.postJson('/v1/auth/verify', body: {
      'phone': phone,
      'code': code,
    });
    return AuthVerifyResponse.fromJson(res);
  }
}

class AuthStartResponse {
  AuthStartResponse({
    required this.otpId,
    required this.expiresAt,
    required this.devCode,
  });

  final String otpId;
  final DateTime expiresAt;
  final String? devCode;

  factory AuthStartResponse.fromJson(Map<String, dynamic> json) {
    return AuthStartResponse(
      otpId: json['otp_id'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      devCode: json['dev_code'] as String?,
    );
  }
}

class AuthVerifyResponse {
  AuthVerifyResponse({
    required this.token,
    required this.userId,
    required this.expiresAt,
  });

  final String token;
  final String userId;
  final DateTime expiresAt;

  factory AuthVerifyResponse.fromJson(Map<String, dynamic> json) {
    return AuthVerifyResponse(
      token: json['token'] as String,
      userId: json['user_id'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }
}

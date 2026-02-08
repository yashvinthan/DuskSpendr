import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../core/security/auth_service.dart';
import '../data/local/session_store.dart';
import '../data/remote/api_client.dart';
import '../data/remote/auth_api.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final store = ref.read(sessionStoreProvider);
  return ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    onUnauthorized: () => store.clear(),
  );
});

final authApiProvider = Provider<AuthApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthApi(client);
});

final localAuthServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final sessionStoreProvider = Provider<SessionStore>((ref) {
  return SessionStore();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    api: ref.watch(authApiProvider),
    store: ref.watch(sessionStoreProvider),
  );
});

class AuthController extends StateNotifier<AuthState> {
  AuthController({required AuthApi api, required SessionStore store})
      : _api = api,
        _store = store,
        super(const AuthState.idle());

  final AuthApi _api;
  final SessionStore _store;

  Future<AuthStartResponse?> startOtp(String phone) async {
    state = const AuthState.loading();
    try {
      final res = await _api.startOtp(phone);
      state = const AuthState.idle();
      return res;
    } catch (e) {
      state = AuthState.error(e.toString());
      return null;
    }
  }

  Future<bool> verifyOtp({required String phone, required String code}) async {
    state = const AuthState.loading();
    try {
      final res = await _api.verifyOtp(phone: phone, code: code);
      await _store.saveSession(token: res.token, userId: res.userId);
      state = const AuthState.authenticated();
      return true;
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }
}

class AuthState {
  const AuthState._({required this.status, this.message});

  final AuthStatus status;
  final String? message;

  const AuthState.idle() : this._(status: AuthStatus.idle);
  const AuthState.loading() : this._(status: AuthStatus.loading);
  const AuthState.authenticated() : this._(status: AuthStatus.authenticated);
  const AuthState.error(String message)
      : this._(status: AuthStatus.error, message: message);
}

enum AuthStatus { idle, loading, authenticated, error }

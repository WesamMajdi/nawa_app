import '../models/auth_result.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class AuthRepository {
  final ApiClient _api;

  AuthRepository(this._api);

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String? handle,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      if (handle != null) 'handle': handle,
    };
    final response = await _api.register(data);
    final result = AuthResult.fromJson(response.data);
    if (result.refreshToken != null) {
      await _api.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken!,
      );
    }
    return result;
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.login({'email': email, 'password': password});
    final result = AuthResult.fromJson(response.data);
    if (result.refreshToken != null) {
      await _api.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken!,
      );
    }
    return result;
  }

  Future<void> logout() async {
    final refreshToken = await _api.getRefreshToken();
    if (refreshToken != null) {
      await _api.logout(refreshToken);
    }
    await _api.clearTokens();
  }

  Future<void> forgotPassword(String email) async {
    await _api.post(ApiEndpoints.forgotPassword, data: {'email': email});
  }

  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    await _api.post(ApiEndpoints.resetPassword, data: {
      'token': token,
      'password': password,
    });
  }

  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _api.post(ApiEndpoints.changePassword, data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
    final result = AuthResult.fromJson(response.data);
    if (result.refreshToken != null) {
      await _api.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken!,
      );
    }
    return result;
  }

  Future<bool> isLoggedIn() async {
    final token = await _api.getAccessToken();
    return token != null;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_endpoints.dart';
import 'api_exceptions.dart';
import 'auth_interceptor.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage;

  static const String _baseUrl = 'https://nawahtareq-001-site1.jtempurl.com/api/v1';

  ApiClient({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    _dio.interceptors.add(AuthInterceptor(_storage, _dio));
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  // Auth endpoints (with X-Client header)
  Future<Response> register(Map<String, dynamic> data) async {
    return _postWithClient(ApiEndpoints.register, data);
  }

  Future<Response> login(Map<String, dynamic> data) async {
    return _postWithClient(ApiEndpoints.login, data);
  }

  Future<Response> refresh(String refreshToken) async {
    return _postWithClient(ApiEndpoints.refresh, {'refreshToken': refreshToken});
  }

  Future<Response> logout(String refreshToken) async {
    return _dio.post(ApiEndpoints.logout, data: {'refreshToken': refreshToken});
  }

  // Generic CRUD
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dio.patch(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Token management
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<String?> getAccessToken() async => _storage.read(key: 'access_token');
  Future<String?> getRefreshToken() async => _storage.read(key: 'refresh_token');

  // Private helpers
  Future<Response> _postWithClient(String path, Map<String, dynamic> data) async {
    try {
      return await _dio.post(
        path,
        data: data,
        options: Options(headers: {'X-Client': 'mobile'}),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      return ApiException.fromJson(e.response!.data);
    }
    return ApiException(
      code: 'network_error',
      title: e.message ?? 'Network error',
      status: e.response?.statusCode ?? 500,
    );
  }
}

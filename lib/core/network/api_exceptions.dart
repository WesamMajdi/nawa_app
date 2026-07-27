class ApiException implements Exception {
  final String code;
  final String title;
  final int status;
  final String? detail;
  final String? traceId;
  final Map<String, List<String>>? errors;

  ApiException({
    required this.code,
    required this.title,
    required this.status,
    this.detail,
    this.traceId,
    this.errors,
  });

  @override
  String toString() => 'ApiException($code): $title';

  static ApiException fromJson(Map<String, dynamic> json) {
    return ApiException(
      code: json['code'] as String? ?? 'unknown',
      title: json['title'] as String? ?? 'Unknown error',
      status: json['status'] as int? ?? 500,
      detail: json['detail'] as String?,
      traceId: json['traceId'] as String?,
      errors: (json['errors'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => e.toString()).toList(),
        ),
      ),
    );
  }
}

class AuthException extends ApiException {
  AuthException({required super.code, required super.status, super.detail})
      : super(title: 'Authentication error');
}

class ValidationException extends ApiException {
  ValidationException({Map<String, List<String>>? errors})
      : super(
          code: 'validation_failed',
          title: 'Validation failed',
          status: 422,
          errors: errors,
        );
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

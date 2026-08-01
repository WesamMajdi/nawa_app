import 'user_model.dart';

class AuthResult {
  final UserModel? user;
  final String accessToken;
  final DateTime expiresAt;
  final String tokenType;
  final String? refreshToken;

  AuthResult({
    this.user,
    required this.accessToken,
    required this.expiresAt,
    required this.tokenType,
    this.refreshToken,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      accessToken: json['accessToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      tokenType: json['tokenType'] as String? ?? 'bearer',
      refreshToken: json['refreshToken'] as String?,
    );
  }
}

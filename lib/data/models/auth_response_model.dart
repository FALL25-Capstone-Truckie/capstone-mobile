import '../../domain/entities/auth_response.dart';
import 'user_model.dart';

class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required super.authToken,
    required super.refreshToken,
    required super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      authToken: json['authToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authToken': authToken,
      'refreshToken': refreshToken,
      'user': (user as UserModel).toJson(),
    };
  }

  AuthResponse toEntity() => this;
}

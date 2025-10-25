import '../../domain/entities/token_response.dart';

class TokenResponseModel extends TokenResponse {
  const TokenResponseModel({
    required super.accessToken,
    super.refreshToken,
  });

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) {
    return TokenResponseModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  TokenResponse toEntity() => this;
}

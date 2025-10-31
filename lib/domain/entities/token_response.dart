import 'package:equatable/equatable.dart';

class TokenResponse extends Equatable {
  final String accessToken;
  final String? refreshToken;

  const TokenResponse({required this.accessToken, this.refreshToken});

  @override
  List<Object?> get props => [accessToken, refreshToken];
}

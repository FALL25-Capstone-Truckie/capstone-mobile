import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthResponse extends Equatable {
  final String authToken;
  final String refreshToken;
  final User user;

  const AuthResponse({
    required this.authToken,
    required this.refreshToken,
    required this.user,
  });

  @override
  List<Object?> get props => [authToken, refreshToken, user];
}

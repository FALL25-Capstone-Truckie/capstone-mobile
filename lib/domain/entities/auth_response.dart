import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthResponse extends Equatable {
  final String authToken;
  final User user;

  const AuthResponse({required this.authToken, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      authToken: json['authToken'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [authToken, user];
}

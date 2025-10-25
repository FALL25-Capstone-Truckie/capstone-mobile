import 'package:equatable/equatable.dart';
import 'role.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool gender;
  final String dateOfBirth;
  final String imageUrl;
  final String status;
  final Role role;
  final String authToken;
  final String? refreshToken;

  const User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.dateOfBirth,
    required this.imageUrl,
    required this.status,
    required this.role,
    required this.authToken,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    fullName,
    email,
    phoneNumber,
    gender,
    dateOfBirth,
    imageUrl,
    status,
    role,
    authToken,
    refreshToken,
  ];
}

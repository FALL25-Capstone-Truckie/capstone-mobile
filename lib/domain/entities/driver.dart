import 'package:equatable/equatable.dart';
import 'user.dart';
import 'role.dart';

class Driver extends Equatable {
  final String id;
  final String identityNumber;
  final String driverLicenseNumber;
  final String cardSerialNumber;
  final String placeOfIssue;
  final DateTime dateOfIssue;
  final DateTime dateOfExpiry;
  final String licenseClass;
  final DateTime dateOfPassing;
  final String status;
  final User userResponse;

  const Driver({
    required this.id,
    required this.identityNumber,
    required this.driverLicenseNumber,
    required this.cardSerialNumber,
    required this.placeOfIssue,
    required this.dateOfIssue,
    required this.dateOfExpiry,
    required this.licenseClass,
    required this.dateOfPassing,
    required this.status,
    required this.userResponse,
  });


  @override
  List<Object?> get props => [
    id,
    identityNumber,
    driverLicenseNumber,
    cardSerialNumber,
    placeOfIssue,
    dateOfIssue,
    dateOfExpiry,
    licenseClass,
    dateOfPassing,
    status,
    userResponse,
  ];
}

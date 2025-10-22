import '../../domain/entities/driver.dart';
import 'user_model.dart';
import 'role_model.dart';

class DriverModel extends Driver {
  const DriverModel({
    required super.id,
    required super.identityNumber,
    required super.driverLicenseNumber,
    required super.cardSerialNumber,
    required super.placeOfIssue,
    required super.dateOfIssue,
    required super.dateOfExpiry,
    required super.licenseClass,
    required super.dateOfPassing,
    required super.status,
    required super.userResponse,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? '',
      identityNumber: json['identityNumber'] ?? '',
      driverLicenseNumber: json['driverLicenseNumber'] ?? '',
      cardSerialNumber: json['cardSerialNumber'] ?? '',
      placeOfIssue: json['placeOfIssue'] ?? '',
      dateOfIssue: json['dateOfIssue'] != null
          ? DateTime.parse(json['dateOfIssue'])
          : DateTime.now(),
      dateOfExpiry: json['dateOfExpiry'] != null
          ? DateTime.parse(json['dateOfExpiry'])
          : DateTime.now(),
      licenseClass: json['licenseClass'] ?? '',
      dateOfPassing: json['dateOfPassing'] != null
          ? DateTime.parse(json['dateOfPassing'])
          : DateTime.now(),
      status: json['status'] ?? '',
      userResponse: json['userResponse'] != null
          ? UserModel.fromJson(json['userResponse'])
          : const UserModel(
              id: '',
              username: '',
              fullName: '',
              email: '',
              phoneNumber: '',
              gender: false,
              dateOfBirth: '',
              imageUrl: '',
              status: '',
              role: RoleModel(
                id: '',
                roleName: '',
                description: '',
                isActive: false,
              ),
              authToken: '',
              refreshToken: '',
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'identityNumber': identityNumber,
      'driverLicenseNumber': driverLicenseNumber,
      'cardSerialNumber': cardSerialNumber,
      'placeOfIssue': placeOfIssue,
      'dateOfIssue': dateOfIssue.toIso8601String(),
      'dateOfExpiry': dateOfExpiry.toIso8601String(),
      'licenseClass': licenseClass,
      'dateOfPassing': dateOfPassing.toIso8601String(),
      'status': status,
      'userResponse': (userResponse as UserModel).toJson(),
    };
  }

  Driver toEntity() => this;
}

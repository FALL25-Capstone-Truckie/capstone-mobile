import '../../domain/entities/role.dart';

class RoleModel extends Role {
  const RoleModel({
    required super.id,
    required super.roleName,
    required super.description,
    required super.isActive,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] ?? '',
      roleName: json['roleName'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roleName': roleName,
      'description': description,
      'isActive': isActive,
    };
  }

  Role toEntity() => this;
}

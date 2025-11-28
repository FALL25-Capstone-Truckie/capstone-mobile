import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:capstone_mobile/domain/entities/notification.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel extends Equatable {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'notificationType', unknownEnumValue: NotificationType.unknown)
  final NotificationType notificationType;

  @JsonKey(name: 'recipientRole')
  final String recipientRole;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'isRead')
  final bool isRead;

  @JsonKey(name: 'emailSent')
  final bool emailSent;

  @JsonKey(name: 'pushNotificationSent')
  final bool pushNotificationSent;

  @JsonKey(name: 'relatedOrderId')
  final String? relatedOrderId;

  @JsonKey(name: 'relatedOrderDetailIds')
  final List<String>? relatedOrderDetailIds;

  @JsonKey(name: 'relatedIssueId')
  final String? relatedIssueId;

  @JsonKey(name: 'relatedVehicleAssignmentId')
  final String? relatedVehicleAssignmentId;

  @JsonKey(name: 'relatedContractId')
  final String? relatedContractId;

  @JsonKey(name: 'metadata')
  final Map<String, dynamic>? metadata;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.notificationType,
    required this.recipientRole,
    required this.createdAt,
    required this.isRead,
    required this.emailSent,
    required this.pushNotificationSent,
    this.relatedOrderId,
    this.relatedOrderDetailIds,
    this.relatedIssueId,
    this.relatedVehicleAssignmentId,
    this.relatedContractId,
    this.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  /// Convert domain entity to data model
  factory NotificationModel.fromEntity(Notification notification) {
    return NotificationModel(
      id: notification.id,
      title: notification.title,
      description: notification.description,
      notificationType: notification.notificationType,
      recipientRole: notification.recipientRole,
      createdAt: notification.createdAt,
      isRead: notification.isRead,
      emailSent: notification.emailSent,
      pushNotificationSent: notification.pushNotificationSent,
      relatedOrderId: notification.relatedOrderId,
      relatedOrderDetailIds: notification.relatedOrderDetailIds,
      relatedIssueId: notification.relatedIssueId,
      relatedVehicleAssignmentId: notification.relatedVehicleAssignmentId,
      relatedContractId: notification.relatedContractId,
      metadata: notification.metadata,
    );
  }

  /// Convert data model to domain entity
  Notification toEntity() {
    return Notification(
      id: id,
      title: title,
      description: description,
      notificationType: notificationType,
      recipientRole: recipientRole,
      createdAt: createdAt,
      isRead: isRead,
      emailSent: emailSent,
      pushNotificationSent: pushNotificationSent,
      relatedOrderId: relatedOrderId,
      relatedOrderDetailIds: relatedOrderDetailIds,
      relatedIssueId: relatedIssueId,
      relatedVehicleAssignmentId: relatedVehicleAssignmentId,
      relatedContractId: relatedContractId,
      metadata: metadata,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    NotificationType? notificationType,
    String? recipientRole,
    DateTime? createdAt,
    bool? isRead,
    bool? emailSent,
    bool? pushNotificationSent,
    String? relatedOrderId,
    List<String>? relatedOrderDetailIds,
    String? relatedIssueId,
    String? relatedVehicleAssignmentId,
    String? relatedContractId,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      notificationType: notificationType ?? this.notificationType,
      recipientRole: recipientRole ?? this.recipientRole,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      emailSent: emailSent ?? this.emailSent,
      pushNotificationSent: pushNotificationSent ?? this.pushNotificationSent,
      relatedOrderId: relatedOrderId ?? this.relatedOrderId,
      relatedOrderDetailIds:
          relatedOrderDetailIds ?? this.relatedOrderDetailIds,
      relatedIssueId: relatedIssueId ?? this.relatedIssueId,
      relatedVehicleAssignmentId:
          relatedVehicleAssignmentId ?? this.relatedVehicleAssignmentId,
      relatedContractId: relatedContractId ?? this.relatedContractId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    notificationType,
    recipientRole,
    createdAt,
    isRead,
    emailSent,
    pushNotificationSent,
    relatedOrderId,
    relatedOrderDetailIds,
    relatedIssueId,
    relatedVehicleAssignmentId,
    relatedContractId,
    metadata,
  ];
}

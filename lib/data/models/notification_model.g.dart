// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      notificationType: $enumDecode(
        _$NotificationTypeEnumMap,
        json['notificationType'],
        unknownValue: NotificationType.unknown,
      ),
      recipientRole: json['recipientRole'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool,
      emailSent: json['emailSent'] as bool,
      pushNotificationSent: json['pushNotificationSent'] as bool,
      relatedOrderId: json['relatedOrderId'] as String?,
      relatedOrderDetailIds: (json['relatedOrderDetailIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      relatedIssueId: json['relatedIssueId'] as String?,
      relatedVehicleAssignmentId: json['relatedVehicleAssignmentId'] as String?,
      relatedContractId: json['relatedContractId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'notificationType': _$NotificationTypeEnumMap[instance.notificationType]!,
      'recipientRole': instance.recipientRole,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
      'emailSent': instance.emailSent,
      'pushNotificationSent': instance.pushNotificationSent,
      'relatedOrderId': instance.relatedOrderId,
      'relatedOrderDetailIds': instance.relatedOrderDetailIds,
      'relatedIssueId': instance.relatedIssueId,
      'relatedVehicleAssignmentId': instance.relatedVehicleAssignmentId,
      'relatedContractId': instance.relatedContractId,
      'metadata': instance.metadata,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.newOrderAssigned: 'NEW_ORDER_ASSIGNED',
  NotificationType.paymentReceived: 'PAYMENT_RECEIVED',
  NotificationType.returnPaymentSuccess: 'RETURN_PAYMENT_SUCCESS',
  NotificationType.sealAssigned: 'SEAL_ASSIGNED',
  NotificationType.damageResolved: 'DAMAGE_RESOLVED',
  NotificationType.orderRejectionResolved: 'ORDER_REJECTION_RESOLVED',
  NotificationType.pickingUpStarted: 'PICKING_UP_STARTED',
  NotificationType.deliveryStarted: 'DELIVERY_STARTED',
  NotificationType.deliveryInProgress: 'DELIVERY_IN_PROGRESS',
  NotificationType.deliveryCompleted: 'DELIVERY_COMPLETED',
  NotificationType.issueReported: 'ISSUE_REPORTED',
  NotificationType.issueResolved: 'ISSUE_RESOLVED',
  NotificationType.rerouteRequired: 'REROUTE_REQUIRED',
  NotificationType.sealReplacement: 'SEAL_REPLACEMENT',
  NotificationType.orderRejection: 'ORDER_REJECTION',
  NotificationType.damage: 'DAMAGE',
  NotificationType.reroute: 'REROUTE',
  NotificationType.penalty: 'PENALTY',
  NotificationType.paymentSuccess: 'PAYMENT_SUCCESS',
  NotificationType.paymentTimeout: 'PAYMENT_TIMEOUT',
  NotificationType.orderStatusChange: 'ORDER_STATUS_CHANGE',
  NotificationType.issueStatusChange: 'ISSUE_STATUS_CHANGE',
  NotificationType.general: 'GENERAL',
  NotificationType.unknown: 'UNKNOWN',
};

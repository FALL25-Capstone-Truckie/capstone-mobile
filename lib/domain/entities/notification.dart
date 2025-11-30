import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification extends Equatable {
  final String id;
  final String title;
  final String description;
  final NotificationType notificationType;
  final String recipientRole;
  final DateTime createdAt;
  final bool isRead;
  final bool emailSent;
  final bool pushNotificationSent;

  // Related entity IDs
  final String? relatedOrderId;
  final List<String>? relatedOrderDetailIds;
  final String? relatedIssueId;
  final String? relatedVehicleAssignmentId;
  final String? relatedContractId;

  // Metadata for additional information
  final Map<String, dynamic>? metadata;

  const Notification({
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

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  Notification copyWith({
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
    return Notification(
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

enum NotificationType {
  // ============= DRIVER NOTIFICATIONS - PRIMARY =============
  @JsonValue('NEW_ORDER_ASSIGNED')
  newOrderAssigned,

  @JsonValue('PAYMENT_RECEIVED')
  paymentReceived,

  @JsonValue('RETURN_PAYMENT_SUCCESS')
  returnPaymentSuccess,

  @JsonValue('SEAL_ASSIGNED')
  sealAssigned,

  @JsonValue('DAMAGE_RESOLVED')
  damageResolved,

  @JsonValue('ORDER_REJECTION_RESOLVED')
  orderRejectionResolved,

  // ============= DRIVER NOTIFICATIONS - ORDER LIFECYCLE =============
  @JsonValue('PICKING_UP_STARTED')
  pickingUpStarted,

  @JsonValue('DELIVERY_STARTED')
  deliveryStarted,

  @JsonValue('DELIVERY_IN_PROGRESS')
  deliveryInProgress,

  @JsonValue('DELIVERY_COMPLETED')
  deliveryCompleted,

  // ============= DRIVER NOTIFICATIONS - ISSUES =============
  @JsonValue('ISSUE_REPORTED')
  issueReported,

  @JsonValue('ISSUE_RESOLVED')
  issueResolved,

  @JsonValue('REROUTE_REQUIRED')
  rerouteRequired,

  // ============= LEGACY TYPES (for backward compatibility) =============
  @JsonValue('SEAL_REPLACEMENT')
  sealReplacement,

  @JsonValue('ORDER_REJECTION')
  orderRejection,

  @JsonValue('DAMAGE')
  damage,

  @JsonValue('REROUTE')
  reroute,

  @JsonValue('PENALTY')
  penalty,

  @JsonValue('PAYMENT_SUCCESS')
  paymentSuccess,

  @JsonValue('PAYMENT_TIMEOUT')
  paymentTimeout,

  @JsonValue('ORDER_STATUS_CHANGE')
  orderStatusChange,

  @JsonValue('ISSUE_STATUS_CHANGE')
  issueStatusChange,

  @JsonValue('GENERAL')
  general,

  // ============= FALLBACK FOR UNKNOWN TYPES =============
  // Used when backend sends a notification type not defined in this enum
  @JsonValue('UNKNOWN')
  unknown,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      // Primary driver notifications
      case NotificationType.newOrderAssigned:
        return 'Đơn hàng mới';
      case NotificationType.paymentReceived:
        return 'Khách đã thanh toán';
      case NotificationType.returnPaymentSuccess:
        return 'Thanh toán trả hàng';
      case NotificationType.sealAssigned:
        return 'Cấp seal mới';
      case NotificationType.damageResolved:
        return 'Sự cố hư hỏng đã giải quyết';
      case NotificationType.orderRejectionResolved:
        return 'Sự cố từ chối đã giải quyết';
      // Order lifecycle
      case NotificationType.pickingUpStarted:
        return 'Bắt đầu lấy hàng';
      case NotificationType.deliveryStarted:
        return 'Bắt đầu giao hàng';
      case NotificationType.deliveryInProgress:
        return 'Sắp giao hàng';
      case NotificationType.deliveryCompleted:
        return 'Hoàn thành giao hàng';
      // Issues
      case NotificationType.issueReported:
        return 'Sự cố đã báo cáo';
      case NotificationType.issueResolved:
        return 'Sự cố đã giải quyết';
      case NotificationType.rerouteRequired:
        return 'Cần tái định tuyến';
      // Legacy types
      case NotificationType.sealReplacement:
        return 'Thay thế seal';
      case NotificationType.orderRejection:
        return 'Từ chối nhận hàng';
      case NotificationType.damage:
        return 'Hàng hóa hư hỏng';
      case NotificationType.reroute:
        return 'Tái định tuyến';
      case NotificationType.penalty:
        return 'Phạt vi phạm';
      case NotificationType.paymentSuccess:
        return 'Thanh toán thành công';
      case NotificationType.paymentTimeout:
        return 'Hết hạn thanh toán';
      case NotificationType.orderStatusChange:
        return 'Thay đổi trạng thái đơn hàng';
      case NotificationType.issueStatusChange:
        return 'Cập nhật sự cố';
      case NotificationType.general:
        return 'Thông báo chung';
      case NotificationType.unknown:
        return 'Thông báo';
    }
  }

  String get icon {
    switch (this) {
      // Primary driver notifications
      case NotificationType.newOrderAssigned:
        return '📦';
      case NotificationType.paymentReceived:
        return '💰';
      case NotificationType.returnPaymentSuccess:
        return '💵';
      case NotificationType.sealAssigned:
        return '🔐';
      case NotificationType.damageResolved:
        return '✅';
      case NotificationType.orderRejectionResolved:
        return '✅';
      // Order lifecycle
      case NotificationType.pickingUpStarted:
        return '📤';
      case NotificationType.deliveryStarted:
        return '🚚';
      case NotificationType.deliveryInProgress:
        return '🚛';
      case NotificationType.deliveryCompleted:
        return '✅';
      // Issues
      case NotificationType.issueReported:
        return '⚠️';
      case NotificationType.issueResolved:
        return '✅';
      case NotificationType.rerouteRequired:
        return '🔄';
      // Legacy types
      case NotificationType.sealReplacement:
        return '🔐';
      case NotificationType.orderRejection:
        return '🚫';
      case NotificationType.damage:
        return '💥';
      case NotificationType.reroute:
        return '🔄';
      case NotificationType.penalty:
        return '⚠️';
      case NotificationType.paymentSuccess:
        return '💰';
      case NotificationType.paymentTimeout:
        return '⏰';
      case NotificationType.orderStatusChange:
        return '📦';
      case NotificationType.issueStatusChange:
        return '🔧';
      case NotificationType.general:
        return '📢';
      case NotificationType.unknown:
        return '📋';
    }
  }

  bool get isHighPriority {
    return [
      NotificationType.newOrderAssigned,
      NotificationType.sealAssigned,
      NotificationType.returnPaymentSuccess,
      NotificationType.sealReplacement,
      NotificationType.orderRejection,
      NotificationType.paymentTimeout,
    ].contains(this);
  }

  bool get isMediumPriority {
    return [
      NotificationType.paymentReceived,
      NotificationType.damageResolved,
      NotificationType.orderRejectionResolved,
      NotificationType.damage,
      NotificationType.reroute,
      NotificationType.rerouteRequired,
    ].contains(this);
  }

  bool get isLowPriority {
    return [
      NotificationType.pickingUpStarted,
      NotificationType.deliveryStarted,
      NotificationType.deliveryInProgress,
      NotificationType.deliveryCompleted,
      NotificationType.issueReported,
      NotificationType.issueResolved,
      NotificationType.penalty,
      NotificationType.general,
      NotificationType.orderStatusChange,
      NotificationType.issueStatusChange,
      NotificationType.paymentSuccess,
    ].contains(this);
  }
}

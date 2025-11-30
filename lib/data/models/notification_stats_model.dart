import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:capstone_mobile/domain/entities/notification.dart';
import 'package:capstone_mobile/domain/repositories/notification_repository.dart';

part 'notification_stats_model.g.dart';

@JsonSerializable()
class NotificationStatsModel extends Equatable {
  @JsonKey(name: 'totalCount')
  final int totalCount;
  
  @JsonKey(name: 'unreadCount')
  final int unreadCount;
  
  @JsonKey(name: 'readCount')
  final int readCount;
  
  @JsonKey(name: 'countByType')
  final Map<String, int> countByType;

  const NotificationStatsModel({
    required this.totalCount,
    required this.unreadCount,
    required this.readCount,
    required this.countByType,
  });

  factory NotificationStatsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationStatsModelToJson(this);

  /// Convert domain entity to data model
  factory NotificationStatsModel.fromEntity(NotificationStats stats) {
    return NotificationStatsModel(
      totalCount: stats.totalCount,
      unreadCount: stats.unreadCount,
      readCount: stats.readCount,
      countByType: stats.countByType.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
    );
  }

  /// Convert data model to domain entity
  NotificationStats toEntity() {
    return NotificationStats(
      totalCount: totalCount,
      unreadCount: unreadCount,
      readCount: readCount,
      countByType: countByType.map(
        (key, value) => MapEntry(
          _parseNotificationType(key),
          value,
        ),
      ),
    );
  }

  NotificationType _parseNotificationType(String typeString) {
    switch (typeString) {
      case 'SEAL_REPLACEMENT':
        return NotificationType.sealReplacement;
      case 'ORDER_REJECTION':
        return NotificationType.orderRejection;
      case 'DAMAGE':
        return NotificationType.damage;
      case 'REROUTE':
        return NotificationType.reroute;
      case 'PENALTY':
        return NotificationType.penalty;
      case 'PAYMENT_SUCCESS':
        return NotificationType.paymentSuccess;
      case 'PAYMENT_TIMEOUT':
        return NotificationType.paymentTimeout;
      case 'ORDER_STATUS_CHANGE':
        return NotificationType.orderStatusChange;
      case 'ISSUE_STATUS_CHANGE':
        return NotificationType.issueStatusChange;
      case 'GENERAL':
      default:
        return NotificationType.general;
    }
  }

  @override
  List<Object?> get props => [
        totalCount,
        unreadCount,
        readCount,
        countByType,
      ];
}

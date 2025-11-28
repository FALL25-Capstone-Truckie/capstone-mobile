import 'package:dartz/dartz.dart';
import 'package:capstone_mobile/domain/entities/notification.dart';
import 'package:capstone_mobile/core/errors/failures.dart';

abstract class NotificationRepository {
  /// Get notifications for the current driver with pagination and filtering
  Future<Either<Failure, List<Notification>>> getNotifications({
    int page = 0,
    int size = 20,
    bool unreadOnly = false,
    NotificationType? notificationType,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get notification by ID
  Future<Either<Failure, Notification>> getNotificationById({
    required String notificationId,
  });

  /// Get notification statistics
  Future<Either<Failure, NotificationStats>> getNotificationStats();

  /// Mark notification as read
  Future<Either<Failure, void>> markAsRead({required String notificationId});

  /// Mark all notifications as read
  Future<Either<Failure, void>> markAllAsRead();

  /// Delete notification
  Future<Either<Failure, void>> deleteNotification({
    required String notificationId,
  });

  /// Get unread count
  Future<Either<Failure, int>> getUnreadCount();
}

class NotificationStats {
  final int totalCount;
  final int unreadCount;
  final int readCount;
  final Map<NotificationType, int> countByType;

  const NotificationStats({
    required this.totalCount,
    required this.unreadCount,
    required this.readCount,
    required this.countByType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationStats &&
          runtimeType == other.runtimeType &&
          totalCount == other.totalCount &&
          unreadCount == other.unreadCount &&
          readCount == other.readCount &&
          countByType == other.countByType;

  @override
  int get hashCode =>
      totalCount.hashCode ^
      unreadCount.hashCode ^
      readCount.hashCode ^
      countByType.hashCode;
}

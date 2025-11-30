import 'package:capstone_mobile/core/errors/exceptions.dart';
import 'package:capstone_mobile/data/datasources/api_client.dart';
import 'package:capstone_mobile/data/models/notification_model.dart';
import 'package:capstone_mobile/data/models/notification_stats_model.dart';

abstract class NotificationRemoteDataSource {
  /// Get notifications from API
  Future<List<NotificationModel>> getNotifications({
    int page = 0,
    int size = 20,
    bool unreadOnly = false,
    String? notificationType,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get notification by ID
  Future<NotificationModel> getNotificationById({
    required String notificationId,
  });

  /// Get notification statistics
  Future<NotificationStatsModel> getNotificationStats();

  /// Mark notification as read
  Future<void> markAsRead({required String notificationId});

  /// Mark all notifications as read
  Future<void> markAllAsRead();

  /// Delete notification
  Future<void> deleteNotification({required String notificationId});

  /// Get unread count
  Future<int> getUnreadCount();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<NotificationModel>> getNotifications({
    int page = 0,
    int size = 20,
    bool unreadOnly = false,
    String? notificationType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Build query parameters (ApiService expects Map<String, String>)
      final queryParams = <String, String>{
        'page': page.toString(),
        'size': size.toString(),
      };

      if (unreadOnly) {
        queryParams['unreadOnly'] = 'true';
      }

      if (notificationType != null) {
        queryParams['notificationType'] = notificationType;
      }

      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }

      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      // Call API - userId will be extracted from JWT token by backend
      final response = await apiClient.dio.get(
        '/notifications',
        queryParameters: queryParams,
      );

      // Parse response
      final content = response.data['content'] as List;
      return content
          .map(
            (json) => NotificationModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get notifications: $e');
    }
  }

  @override
  Future<NotificationModel> getNotificationById({
    required String notificationId,
  }) async {
    try {
      final response = await apiClient.dio.get(
        '/notifications/$notificationId',
      );
      return NotificationModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: 'Failed to get notification: $e');
    }
  }

  @override
  Future<NotificationStatsModel> getNotificationStats() async {
    try {
      final response = await apiClient.dio.get('/notifications/stats');
      return NotificationStatsModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: 'Failed to get notification stats: $e');
    }
  }

  @override
  Future<void> markAsRead({required String notificationId}) async {
    try {
      await apiClient.dio.put('/notifications/$notificationId/read');
    } catch (e) {
      throw ServerException(message: 'Failed to mark notification as read: $e');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await apiClient.dio.put('/notifications/read-all');
    } catch (e) {
      throw ServerException(message: 'Failed to mark all as read: $e');
    }
  }

  @override
  Future<void> deleteNotification({required String notificationId}) async {
    try {
      await apiClient.dio.delete('/notifications/$notificationId');
    } catch (e) {
      throw ServerException(message: 'Failed to delete notification: $e');
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final stats = await getNotificationStats();
      return stats.unreadCount;
    } catch (e) {
      throw ServerException(message: 'Failed to get unread count: $e');
    }
  }
}

import 'package:flutter/foundation.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';

/// Simple service for managing driver notifications via REST API
/// Backend automatically identifies driver from JWT token (like /my-orders, /my-address)
/// No WebSocket needed - just REST API calls
class DriverNotificationService extends ChangeNotifier {
  final NotificationRepository _repository;

  List<Notification> _notifications = [];
  NotificationStats? _stats;
  bool _isLoading = false;
  String? _errorMessage;

  DriverNotificationService(this._repository);

  // Getters
  List<Notification> get notifications => _notifications;
  NotificationStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _stats?.unreadCount ?? 0;

  /// Fetch notifications for current driver (JWT auth)
  /// Backend uses UserContextUtils to get driver ID from token automatically
  Future<void> fetchNotifications({
    int page = 0,
    int size = 20,
    bool unreadOnly = false,
    NotificationType? type,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getNotifications(
        page: page,
        size: size,
        unreadOnly: unreadOnly,
        notificationType: type,
      );

      result.fold(
        (failure) {
          _errorMessage = failure.message;
          _isLoading = false;
          notifyListeners();
        },
        (fetchedNotifications) {
          if (page == 0) {
            _notifications = fetchedNotifications;
          } else {
            _notifications.addAll(fetchedNotifications);
          }
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = 'Lỗi khi tải thông báo: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch notification statistics for current driver
  /// Backend automatically gets driver ID from JWT
  Future<void> fetchStats() async {
    try {
      final result = await _repository.getNotificationStats();

      result.fold(
        (failure) {
          debugPrint('Failed to fetch notification stats: ${failure.message}');
        },
        (fetchedStats) {
          _stats = fetchedStats;
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('Error fetching notification stats: $e');
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final result = await _repository.markAsRead(
        notificationId: notificationId,
      );

      return result.fold(
        (failure) {
          _errorMessage = failure.message;
          notifyListeners();
          return false;
        },
        (_) {
          // Update local notification
          final index = _notifications.indexWhere(
            (n) => n.id == notificationId,
          );
          if (index != -1) {
            _notifications[index] = _notifications[index].copyWith(
              isRead: true,
            );

            // Update stats
            if (_stats != null) {
              _stats = NotificationStats(
                unreadCount: _stats!.unreadCount > 0
                    ? _stats!.unreadCount - 1
                    : 0,
                readCount: _stats!.readCount + 1,
                totalCount: _stats!.totalCount,
                countByType: _stats!.countByType,
              );
            }

            notifyListeners();
          }
          return true;
        },
      );
    } catch (e) {
      _errorMessage = 'Lỗi khi đánh dấu đã đọc: $e';
      notifyListeners();
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final result = await _repository.markAllAsRead();

      return result.fold(
        (failure) {
          _errorMessage = failure.message;
          notifyListeners();
          return false;
        },
        (_) {
          // Update all local notifications
          _notifications = _notifications
              .map((n) => n.copyWith(isRead: true))
              .toList();

          // Update stats
          if (_stats != null) {
            _stats = NotificationStats(
              unreadCount: 0,
              readCount: _stats!.totalCount,
              totalCount: _stats!.totalCount,
              countByType: _stats!.countByType,
            );
          }

          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _errorMessage = 'Lỗi khi đánh dấu tất cả đã đọc: $e';
      notifyListeners();
      return false;
    }
  }

  /// Refresh notifications (pull-to-refresh)
  Future<void> refresh() async {
    await Future.wait([fetchNotifications(page: 0), fetchStats()]);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

import 'package:dartz/dartz.dart';
import 'package:capstone_mobile/core/errors/exceptions.dart';
import 'package:capstone_mobile/core/errors/failures.dart';
import 'package:capstone_mobile/data/datasources/notification_remote_data_source.dart';
import 'package:capstone_mobile/domain/entities/notification.dart';
import 'package:capstone_mobile/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Notification>>> getNotifications({
    int page = 0,
    int size = 20,
    bool unreadOnly = false,
    NotificationType? notificationType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final notificationModels = await remoteDataSource.getNotifications(
        page: page,
        size: size,
        unreadOnly: unreadOnly,
        notificationType: notificationType?.toString(),
        startDate: startDate,
        endDate: endDate,
      );

      final notifications = notificationModels
          .map((model) => model.toEntity())
          .toList();

      return Right(notifications);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Notification>> getNotificationById({
    required String notificationId,
  }) async {
    try {
      final notificationModel = await remoteDataSource.getNotificationById(
        notificationId: notificationId,
      );

      return Right(notificationModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, NotificationStats>> getNotificationStats() async {
    try {
      final statsModel = await remoteDataSource.getNotificationStats();
      return Right(statsModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required String notificationId,
  }) async {
    try {
      await remoteDataSource.markAsRead(notificationId: notificationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification({
    required String notificationId,
  }) async {
    try {
      await remoteDataSource.deleteNotification(notificationId: notificationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await remoteDataSource.getUnreadCount();
      return Right(count);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}

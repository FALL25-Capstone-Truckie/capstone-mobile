import 'package:dartz/dartz.dart';
import 'package:capstone_mobile/core/errors/failures.dart';
import 'package:capstone_mobile/core/usecases/usecase.dart';
import 'package:capstone_mobile/domain/repositories/notification_repository.dart';

class MarkNotificationReadParams {
  final String notificationId;

  const MarkNotificationReadParams({required this.notificationId});
}

class MarkNotificationReadUseCase
    implements UseCase<void, MarkNotificationReadParams> {
  final NotificationRepository repository;

  MarkNotificationReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkNotificationReadParams params) {
    return repository.markAsRead(notificationId: params.notificationId);
  }

  /// Mark all notifications as read
  Future<Either<Failure, void>> callMarkAllAsRead() {
    return repository.markAllAsRead();
  }
}

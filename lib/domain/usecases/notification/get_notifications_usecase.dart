import 'package:dartz/dartz.dart';
import 'package:capstone_mobile/core/errors/failures.dart';
import 'package:capstone_mobile/core/usecases/usecase.dart';
import 'package:capstone_mobile/domain/entities/notification.dart';
import 'package:capstone_mobile/domain/repositories/notification_repository.dart';

class GetNotificationsParams {
  final int page;
  final int size;
  final bool unreadOnly;
  final NotificationType? type;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetNotificationsParams({
    this.page = 0,
    this.size = 20,
    this.unreadOnly = false,
    this.type,
    this.startDate,
    this.endDate,
  });
}

class GetNotificationsUseCase
    implements UseCase<List<Notification>, GetNotificationsParams> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Notification>>> call(
    GetNotificationsParams params,
  ) {
    return repository.getNotifications(
      page: params.page,
      size: params.size,
      unreadOnly: params.unreadOnly,
      notificationType: params.type,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

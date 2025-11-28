import 'package:dartz/dartz.dart';
import 'package:capstone_mobile/core/errors/failures.dart';
import 'package:capstone_mobile/core/usecases/usecase.dart';
import 'package:capstone_mobile/domain/repositories/notification_repository.dart';

class GetNotificationStatsUseCase
    implements NoParamsUseCase<NotificationStats> {
  final NotificationRepository repository;

  GetNotificationStatsUseCase(this.repository);

  @override
  Future<Either<Failure, NotificationStats>> call() {
    return repository.getNotificationStats();
  }
}

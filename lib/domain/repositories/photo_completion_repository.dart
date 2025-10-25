import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';

abstract class PhotoCompletionRepository {
  Future<Either<Failure, bool>> uploadPhoto(String orderId, String photoPath);
}

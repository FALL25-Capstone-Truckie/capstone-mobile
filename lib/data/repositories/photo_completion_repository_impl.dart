import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/photo_completion_repository.dart';
import '../datasources/photo_completion_data_source.dart';

class PhotoCompletionRepositoryImpl implements PhotoCompletionRepository {
  final PhotoCompletionDataSource dataSource;

  PhotoCompletionRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, bool>> uploadPhoto(String orderId, String photoPath) async {
    try {
      final result = await dataSource.uploadPhoto(orderId, photoPath);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:capstone_mobile/core/errors/failures.dart';

/// Base class for all use cases
/// Type: Return type of the use case
/// Params: Parameters required for the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case with no parameters
abstract class NoParamsUseCase<Type> {
  Future<Either<Failure, Type>> call();
}

import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/vehicle_fuel_consumption_repository.dart';
import '../datasources/vehicle_fuel_consumption_data_source.dart';

class VehicleFuelConsumptionRepositoryImpl implements VehicleFuelConsumptionRepository {
  final VehicleFuelConsumptionDataSource dataSource;

  VehicleFuelConsumptionRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, String>> createVehicleFuelConsumption(
    String orderId,
    double fuelConsumption,
    double odometer,
  ) async {
    try {
      final result = await dataSource.createVehicleFuelConsumption(
        orderId,
        fuelConsumption,
        odometer,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getByVehicleAssignmentId(
    String vehicleAssignmentId,
  ) async {
    return await dataSource.getByVehicleAssignmentId(vehicleAssignmentId);
  }

  @override
  Future<Either<Failure, bool>> updateFinalReading({
    required String fuelConsumptionId,
    required double odometerReadingAtEnd,
    required File odometerImage,
  }) async {
    return await dataSource.updateFinalReading(
      fuelConsumptionId: fuelConsumptionId,
      odometerReadingAtEnd: odometerReadingAtEnd,
      odometerImage: odometerImage,
    );
  }
}

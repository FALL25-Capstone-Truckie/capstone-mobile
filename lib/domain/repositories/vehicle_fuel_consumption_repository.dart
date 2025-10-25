import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';

abstract class VehicleFuelConsumptionRepository {
  Future<Either<Failure, String>> createVehicleFuelConsumption(
    String orderId,
    double fuelConsumption,
    double odometer,
  );
  
  Future<Either<Failure, Map<String, dynamic>>> getByVehicleAssignmentId(
    String vehicleAssignmentId,
  );
  
  Future<Either<Failure, bool>> updateFinalReading({
    required String fuelConsumptionId,
    required double odometerReadingAtEnd,
    required File odometerImage,
  });
}

import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';

abstract class VehicleFuelConsumptionRepository {
  Future<Either<Failure, String>> createVehicleFuelConsumption(
    String orderId,
    double fuelConsumption,
    double odometer,
  );
}

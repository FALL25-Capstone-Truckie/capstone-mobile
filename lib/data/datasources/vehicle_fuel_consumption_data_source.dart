import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_client.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';

abstract class VehicleFuelConsumptionDataSource {
  /// Update final odometer reading with image
  Future<Either<Failure, bool>> updateFinalReading({
    required String fuelConsumptionId,
    required double odometerReadingAtEnd,
    required File odometerImage,
  });
  
  /// Get fuel consumption by vehicle assignment ID
  Future<Either<Failure, Map<String, dynamic>>> getByVehicleAssignmentId(String vehicleAssignmentId);
}

class VehicleFuelConsumptionDataSourceImpl implements VehicleFuelConsumptionDataSource {
  final ApiClient _apiClient;

  VehicleFuelConsumptionDataSourceImpl(this._apiClient);

  @override
  Future<Either<Failure, bool>> updateFinalReading({
    required String fuelConsumptionId,
    required double odometerReadingAtEnd,
    required File odometerImage,
  }) async {
    try {
      debugPrint('========== ODOMETER END UPLOAD DEBUG INFO ==========');
      debugPrint('fuelConsumptionId: $fuelConsumptionId');
      debugPrint('odometerReadingAtEnd: $odometerReadingAtEnd');
      debugPrint('odometerReadingAtEnd type: ${odometerReadingAtEnd.runtimeType}');
      debugPrint('odometerImage path: ${odometerImage.path}');
      debugPrint('odometerImage exists: ${odometerImage.existsSync()}');
      debugPrint('odometerImage size: ${odometerImage.lengthSync()} bytes');

      // Create multipart form data
      final multipartFile = await MultipartFile.fromFile(
        odometerImage.path,
        filename: 'odometer_end_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      
      final formData = FormData.fromMap({
        'id': fuelConsumptionId,
        'odometerReadingAtEnd': odometerReadingAtEnd.toStringAsFixed(2),
        'odometerAtEndImage': multipartFile,
      });
      
      debugPrint('Form data to send:');
      debugPrint('  - id: $fuelConsumptionId');
      debugPrint('  - odometerReadingAtEnd: ${odometerReadingAtEnd.toStringAsFixed(2)}');
      debugPrint('  - odometerAtEndImage: ${multipartFile.filename}');

      final response = await _apiClient.dio.put(
        '/vehicle-fuel-consumptions/final-reading',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {'Accept': '*/*'},
        ),
      );

      debugPrint('========== RESPONSE DEBUG INFO ==========');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');
      debugPrint('========== END RESPONSE DEBUG INFO ==========');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return const Right(true);
        } else {
          return Left(
            ServerFailure(
              message: responseData['message'] ?? 'Lỗi khi cập nhật đồng hồ cuối',
            ),
          );
        }
      } else {
        return Left(
          ServerFailure(
            message: 'Lỗi khi cập nhật đồng hồ cuối: ${response.statusCode}',
          ),
        );
      }
    } on DioException catch (e) {
      debugPrint('========== ERROR DEBUG INFO ==========');
      debugPrint('DioException: ${e.message}');
      debugPrint('DioException type: ${e.type}');
      debugPrint('DioException response status: ${e.response?.statusCode}');
      debugPrint('DioException response data: ${e.response?.data}');
      debugPrint('========== END ERROR DEBUG INFO ==========');
      return Left(
        ServerFailure(message: e.message ?? 'Lỗi kết nối đến máy chủ'),
      );
    } on ServerException catch (e) {
      debugPrint('ServerException: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getByVehicleAssignmentId(String vehicleAssignmentId) async {
    try {
      debugPrint('Getting fuel consumption for vehicle assignment: $vehicleAssignmentId');
      
      final response = await _apiClient.dio.get(
        '/vehicle-fuel-consumptions/vehicle-assignment/$vehicleAssignmentId',
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(
          ServerFailure(
            message: 'Lỗi khi lấy thông tin nhiên liệu: ${response.statusCode}',
          ),
        );
      }
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      return Left(
        ServerFailure(message: e.message ?? 'Lỗi kết nối đến máy chủ'),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_client.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';

abstract class OrderDataSource {
  /// Update order status to ONGOING_DELIVERED when near delivery point (within 3km)
  Future<Either<Failure, bool>> updateToOngoingDelivered(String orderId);
  
  /// Update order status to DELIVERED when arriving at delivery point
  Future<Either<Failure, bool>> updateToDelivered(String orderId);
  
  /// Update order status to SUCCESSFUL when driver confirms trip completion
  Future<Either<Failure, bool>> updateToSuccessful(String orderId);
}

class OrderDataSourceImpl implements OrderDataSource {
  final ApiClient _apiClient;

  OrderDataSourceImpl(this._apiClient);

  @override
  Future<Either<Failure, bool>> updateToOngoingDelivered(String orderId) async {
    try {
      final endpoint = '/orders/$orderId/start-ongoing-delivery';
      debugPrint('🔵 Updating order to ONGOING_DELIVERED');
      debugPrint('   - Order ID: $orderId');
      debugPrint('   - Endpoint: $endpoint');
      debugPrint('   - Full URL: ${_apiClient.dio.options.baseUrl}$endpoint');
      
      final response = await _apiClient.dio.put(endpoint);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return const Right(true);
        } else {
          return Left(
            ServerFailure(
              message: responseData['message'] ?? 'Lỗi khi cập nhật trạng thái đơn hàng',
            ),
          );
        }
      } else {
        return Left(
          ServerFailure(
            message: 'Lỗi khi cập nhật trạng thái: ${response.statusCode}',
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

  @override
  Future<Either<Failure, bool>> updateToDelivered(String orderId) async {
    try {
      final endpoint = '/orders/$orderId/arrive-at-delivery';
      debugPrint('🔵 Updating order to DELIVERED');
      debugPrint('   - Order ID: $orderId');
      debugPrint('   - Endpoint: $endpoint');
      debugPrint('   - Full URL: ${_apiClient.dio.options.baseUrl}$endpoint');
      
      final response = await _apiClient.dio.put(endpoint);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return const Right(true);
        } else {
          return Left(
            ServerFailure(
              message: responseData['message'] ?? 'Lỗi khi cập nhật trạng thái đơn hàng',
            ),
          );
        }
      } else {
        return Left(
          ServerFailure(
            message: 'Lỗi khi cập nhật trạng thái: ${response.statusCode}',
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

  @override
  Future<Either<Failure, bool>> updateToSuccessful(String orderId) async {
    try {
      final endpoint = '/orders/$orderId/complete-trip';
      debugPrint('🔵 Updating order to SUCCESSFUL');
      debugPrint('   - Order ID: $orderId');
      debugPrint('   - Endpoint: $endpoint');
      debugPrint('   - Full URL: ${_apiClient.dio.options.baseUrl}$endpoint');
      
      final response = await _apiClient.dio.put(endpoint);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return const Right(true);
        } else {
          return Left(
            ServerFailure(
              message: responseData['message'] ?? 'Lỗi khi hoàn thành chuyến xe',
            ),
          );
        }
      } else {
        return Left(
          ServerFailure(
            message: 'Lỗi khi hoàn thành chuyến xe: ${response.statusCode}',
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

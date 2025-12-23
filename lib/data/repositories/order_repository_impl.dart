import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../datasources/api_client.dart';
import '../datasources/order_data_source.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_detail_status.dart';
import '../../domain/entities/order_with_details.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';
import '../models/order_with_details_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiClient _apiClient;
  final OrderDataSource _orderDataSource;

  OrderRepositoryImpl({
    required ApiClient apiClient,
    required OrderDataSource orderDataSource,
  }) : _apiClient = apiClient,
       _orderDataSource = orderDataSource;

  @override
  Future<Either<Failure, List<Order>>> getDriverOrders() async {
    try {
      final response = await _apiClient.dio.get(
        '/orders/get-list-order-for-driver',
      );

      if (response.data['success'] == true) {
        // Handle null or empty data - backend now returns empty list instead of error
        final dynamic dataValue = response.data['data'];
        if (dataValue == null) {
          return const Right([]);
        }

        final List<dynamic> ordersJson = dataValue as List<dynamic>;
        final List<Order> orders = ordersJson
            .map((orderJson) => OrderModel.fromJson(orderJson))
            .toList();
        return Right(orders);
      } else {
        return Left(
          ServerFailure(
            message: response.data['message'] ?? 'Lỗi khi lấy danh sách đơn hàng',
          ),
        );
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data is Map
          ? (e.response!.data['message']?.toString() ?? '')
          : (e.message ?? '');

      return Left(
        ServerFailure(
          message: message.isNotEmpty
              ? message
              : 'Lỗi kết nối đến máy chủ (${e.response?.statusCode ?? ''})',
          statusCode: statusCode,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderWithDetails>> getOrderDetails(
    String orderId,
  ) async {
    try {
      final response = await _apiClient.dio.get(
        '/orders/get-order-by-id/$orderId',
      );

      if (response.data['success'] == true &&
          response.data['data'] != null &&
          response.data['data']['order'] != null) {
        final orderJson = response.data['data']['order'];
        final orderWithDetails = OrderWithDetailsModel.fromJson(orderJson);
        return Right(orderWithDetails);
      } else {
        return Left(
          ServerFailure(
            message: response.data['message'] ?? 'Lỗi khi lấy chi tiết đơn hàng',
          ),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderWithDetails>> getOrderDetailsForDriver(
    String orderId,
  ) async {
    try {
      final response = await _apiClient.dio.get(
        '/orders/get-order-for-driver-by-order-id/$orderId',
      );

      if (response.data['success'] == true &&
          response.data['data'] != null &&
          response.data['data']['order'] != null) {
        final orderJson = response.data['data']['order'];
        final orderWithDetails = OrderWithDetailsModel.fromJson(orderJson);
        return Right(orderWithDetails);
      } else {
        return Left(
          ServerFailure(
            message: response.data['message'] ?? 'Lỗi khi lấy chi tiết đơn hàng',
          ),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateToOngoingDelivered(String orderId) async {
    return await _orderDataSource.updateToOngoingDelivered(orderId);
  }

  @override
  Future<Either<Failure, bool>> updateToDelivered(String orderId) async {
    return await _orderDataSource.updateToDelivered(orderId);
  }

  @override
  Future<Either<Failure, bool>> updateToSuccessful(String orderId) async {
    return await _orderDataSource.updateToSuccessful(orderId);
  }

  @override
  Future<Either<Failure, bool>> updateOrderDetailStatus({
    required String assignmentId,
    required OrderDetailStatus status,
  }) async {
    return await _orderDataSource.updateOrderDetailStatus(
      assignmentId: assignmentId,
      status: status,
    );
  }
}

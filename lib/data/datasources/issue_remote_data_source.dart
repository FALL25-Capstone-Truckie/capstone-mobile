import 'dart:convert';
import '../../core/services/api_service.dart';
import '../models/order_rejection_detail_response.dart';

class IssueRemoteDataSource {
  final ApiService _apiService;

  IssueRemoteDataSource(this._apiService);

  /// Report order rejection by recipient (Driver)
  Future<Map<String, dynamic>> reportOrderRejection({
    required String vehicleAssignmentId,
    required String issueTypeId,
    String? description,
    double? locationLatitude,
    double? locationLongitude,
  }) async {
    try {
      final response = await _apiService.post(
        '/issues/order-rejection',
        {
          'vehicleAssignmentId': vehicleAssignmentId,
          'issueTypeId': issueTypeId,
          'description': description,
          'locationLatitude': locationLatitude,
          'locationLongitude': locationLongitude,
        },
      );
      return response['data'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get ORDER_REJECTION issue detail
  Future<OrderRejectionDetailResponse> getOrderRejectionDetail(String issueId) async {
    try {
      final response = await _apiService.get(
        '/issues/order-rejection/$issueId/detail',
      );
      return OrderRejectionDetailResponse.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  /// Confirm return delivery at pickup location (Driver)
  Future<Map<String, dynamic>> confirmReturnDelivery({
    required String issueId,
    required List<String> returnDeliveryImages,
  }) async {
    try {
      final response = await _apiService.put(
        '/issues/order-rejection/confirm-return',
        {
          'issueId': issueId,
          'returnDeliveryImages': returnDeliveryImages,
        },
      );
      return response['data'];
    } catch (e) {
      rethrow;
    }
  }

  /// Upload image to server
  Future<String> uploadImage(String filePath) async {
    try {
      // For file upload, we need to use a different approach with http.Client
      // This would need to be implemented in ApiService or use a separate service
      throw UnimplementedError('File upload needs to be implemented in ApiService');
    } catch (e) {
      rethrow;
    }
  }
}

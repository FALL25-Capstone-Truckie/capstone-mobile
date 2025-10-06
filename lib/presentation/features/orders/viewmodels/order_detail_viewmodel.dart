import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show debugPrint;

import '../../../../domain/entities/order_detail.dart';
import '../../../../domain/entities/order_with_details.dart';
import '../../../../domain/usecases/orders/get_order_details_usecase.dart';

enum OrderDetailState { initial, loading, loaded, error }

class OrderDetailViewModel extends ChangeNotifier {
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;

  OrderDetailState _state = OrderDetailState.initial;
  OrderWithDetails? _orderWithDetails;
  String _errorMessage = '';
  List<List<LatLng>> _routeSegments = [];
  int _selectedSegmentIndex = 0;

  OrderDetailState get state => _state;
  OrderWithDetails? get orderWithDetails => _orderWithDetails;
  String get errorMessage => _errorMessage;
  List<List<LatLng>> get routeSegments => _routeSegments;
  int get selectedSegmentIndex => _selectedSegmentIndex;
  List<LatLng> get selectedRoute =>
      _routeSegments.isNotEmpty && _selectedSegmentIndex < _routeSegments.length
      ? _routeSegments[_selectedSegmentIndex]
      : [];

  OrderDetailViewModel({required GetOrderDetailsUseCase getOrderDetailsUseCase})
    : _getOrderDetailsUseCase = getOrderDetailsUseCase;

  Future<void> getOrderDetails(String orderId) async {
    _state = OrderDetailState.loading;
    notifyListeners();

    final result = await _getOrderDetailsUseCase(orderId);

    result.fold(
      (failure) {
        _state = OrderDetailState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (orderWithDetails) {
        _state = OrderDetailState.loaded;
        _orderWithDetails = orderWithDetails;
        _parseRouteSegments();
        notifyListeners();
      },
    );
  }

  void selectSegment(int index) {
    if (index >= 0 && index < _routeSegments.length) {
      _selectedSegmentIndex = index;
      notifyListeners();
    }
  }

  void _parseRouteSegments() {
    _routeSegments = [];

    if (_orderWithDetails == null || _orderWithDetails!.orderDetails.isEmpty) {
      return;
    }

    final orderDetail = _orderWithDetails!.orderDetails.first;
    if (orderDetail.vehicleAssignment == null ||
        orderDetail.vehicleAssignment!.journeyHistories.isEmpty) {
      return;
    }

    final journeyHistory =
        orderDetail.vehicleAssignment!.journeyHistories.first;

    for (var segment in journeyHistory.journeySegments) {
      try {
        final List<LatLng> points = [];
        final List<dynamic> coordinates = json.decode(
          segment.pathCoordinatesJson,
        );

        for (var coordinate in coordinates) {
          if (coordinate is List && coordinate.length >= 2) {
            // Chú ý: Trong JSON, tọa độ được lưu dưới dạng [longitude, latitude]
            final double lng = coordinate[0].toDouble();
            final double lat = coordinate[1].toDouble();
            points.add(LatLng(lat, lng));
          }
        }

        if (points.isNotEmpty) {
          _routeSegments.add(points);
        }
      } catch (e) {
        debugPrint('Error parsing route segment: $e');
      }
    }
  }
}

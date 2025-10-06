import 'package:flutter/foundation.dart';

import '../../../../domain/entities/order.dart';
import '../../../../domain/usecases/orders/get_driver_orders_usecase.dart';

enum OrderListState { initial, loading, loaded, error }

class OrderListViewModel extends ChangeNotifier {
  final GetDriverOrdersUseCase _getDriverOrdersUseCase;

  OrderListState _state = OrderListState.initial;
  List<Order> _orders = [];
  String _errorMessage = '';

  OrderListState get state => _state;
  List<Order> get orders => _orders;
  String get errorMessage => _errorMessage;

  OrderListViewModel({required GetDriverOrdersUseCase getDriverOrdersUseCase})
    : _getDriverOrdersUseCase = getDriverOrdersUseCase;

  Future<void> getDriverOrders() async {
    _state = OrderListState.loading;
    notifyListeners();

    final result = await _getDriverOrdersUseCase();

    result.fold(
      (failure) {
        _state = OrderListState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (orders) {
        _state = OrderListState.loaded;
        _orders = orders;
        notifyListeners();
      },
    );
  }

  // Lọc đơn hàng theo trạng thái
  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // Tìm kiếm đơn hàng
  List<Order> searchOrders(String query) {
    if (query.isEmpty) return _orders;

    final lowercaseQuery = query.toLowerCase();
    return _orders.where((order) {
      return order.orderCode.toLowerCase().contains(lowercaseQuery) ||
          order.receiverName.toLowerCase().contains(lowercaseQuery) ||
          order.receiverPhone.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}

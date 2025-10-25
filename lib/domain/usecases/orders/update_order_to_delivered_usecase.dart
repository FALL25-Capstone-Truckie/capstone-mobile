import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/order_repository.dart';

/// Use case to update order status to DELIVERED when arriving at delivery point
class UpdateOrderToDeliveredUseCase {
  final OrderRepository _orderRepository;

  UpdateOrderToDeliveredUseCase(this._orderRepository);

  Future<Either<Failure, bool>> call(String orderId) async {
    return await _orderRepository.updateToDelivered(orderId);
  }
}

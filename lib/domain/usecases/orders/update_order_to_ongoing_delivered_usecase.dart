import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/order_repository.dart';

/// Use case to update order status to ONGOING_DELIVERED when near delivery point
class UpdateOrderToOngoingDeliveredUseCase {
  final OrderRepository _orderRepository;

  UpdateOrderToOngoingDeliveredUseCase(this._orderRepository);

  Future<Either<Failure, bool>> call(String orderId) async {
    return await _orderRepository.updateToOngoingDelivered(orderId);
  }
}

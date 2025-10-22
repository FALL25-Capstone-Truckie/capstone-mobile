import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/order_repository.dart';

/// Use case to update order status to SUCCESSFUL when driver confirms trip completion
class UpdateOrderToSuccessfulUseCase {
  final OrderRepository _orderRepository;

  UpdateOrderToSuccessfulUseCase(this._orderRepository);

  Future<Either<Failure, bool>> call(String orderId) async {
    return await _orderRepository.updateToSuccessful(orderId);
  }
}

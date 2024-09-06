import 'package:dartz/dartz.dart';
import 'package:eshop/domain/entities/order/order_detail_response.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/order/order_details.dart';
import '../../repositories/order_repository.dart';

class AddOrderUseCase implements UseCase<OrderDetailResponse, OrderDetailResponse> {
  final OrderRepository repository;
  AddOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderDetailResponse>> call(OrderDetailResponse params) async {
    return await repository.addOrder(params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:eshop/domain/entities/order/order_detail_response.dart';

import '../../../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/order/order_details.dart';

abstract class OrderRepository {
  Future<Either<Failure, bool>> addOrder(OrderDetailResponse params);
  Future<Either<Failure, List<OrderDetails>>> getRemoteOrders();
  Future<Either<Failure, List<OrderDetails>>> getCachedOrders();
  Future<Either<Failure, NoParams>> clearLocalOrders();
}
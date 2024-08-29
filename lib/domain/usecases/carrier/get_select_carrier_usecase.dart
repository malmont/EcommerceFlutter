


import 'package:dartz/dartz.dart';
import 'package:eshop/core/error/failures.dart';
import 'package:eshop/core/usecases/usecase.dart';
import 'package:eshop/domain/entities/carrier.dart';
import 'package:eshop/domain/repositories/carrier_repository.dart';

class GetSelectCarrierUsecase implements UseCase<Carrier, NoParams> {
  final CarrierRepository repository;
  GetSelectCarrierUsecase(this.repository);

  @override
  Future<Either<Failure, Carrier>> call(NoParams params) async {
    return await repository.getSelectedCarrier();
  }
}

import 'package:dartz/dartz.dart';
import 'package:eshop/core/error/failures.dart';
import 'package:eshop/core/usecases/usecase.dart';
import 'package:eshop/data/models/carrier_model.dart';
import 'package:eshop/domain/entities/carrier.dart';
import 'package:eshop/domain/repositories/carrier_repository.dart';

class SelectCarrierUsecase implements UseCase<Carrier, CarrierModel> {
  final CarrierRepository repository;
  SelectCarrierUsecase(this.repository);

  @override
  Future<Either<Failure, Carrier>> call(Carrier params) async {
    return await repository.selectCarrier(params);
  }
}
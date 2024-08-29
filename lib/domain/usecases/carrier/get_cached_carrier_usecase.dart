

import 'package:dartz/dartz.dart';
import 'package:eshop/core/error/failures.dart';
import 'package:eshop/core/usecases/usecase.dart';
import 'package:eshop/domain/entities/carrier.dart';
import 'package:eshop/domain/repositories/carrier_repository.dart';

class GetCachedCarrierUsecase  implements UseCase<List<Carrier>, NoParams> {
  final CarrierRepository repository;
  GetCachedCarrierUsecase(this.repository);

  @override
  Future<Either<Failure, List<Carrier>>> call(NoParams params) async {
    return await repository.getCachedCarriers();
  }
}

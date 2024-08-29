import 'package:dartz/dartz.dart';
import 'package:eshop/core/usecases/usecase.dart';
import 'package:eshop/data/models/carrier_model.dart';
import 'package:eshop/domain/entities/carrier.dart';

import '../../core/error/failures.dart';


abstract class CarrierRepository {
  Future<Either<Failure, List<Carrier>>> getRemoteCarriers();
  Future<Either<Failure, List<Carrier>>> getCachedCarriers();
  // Future<Either<Failure, Carrier>> addCarrier(CarrierModel param);
  Future<Either<Failure, Carrier>> selectCarrier(Carrier param);
  Future<Either<Failure, Carrier>> getSelectedCarrier();
}
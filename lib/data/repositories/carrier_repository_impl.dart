import 'package:dartz/dartz.dart';
import 'package:eshop/core/error/failures.dart';
import 'package:eshop/core/network/network_info.dart';
import 'package:eshop/data/data_sources/local/carrier_local_data_source.dart';
import 'package:eshop/data/data_sources/local/user_local_data_source.dart';
import 'package:eshop/data/data_sources/remote/carrier_remote_data_source.dart';
import 'package:eshop/data/models/carrier_model.dart';
import 'package:eshop/domain/entities/carrier.dart';
import 'package:eshop/domain/repositories/carrier_repository.dart';

class CarrierRepositoryImpl implements CarrierRepository {
  final CarrierLocalDataSource localDataSource;
  final CarrierRemoteDataSource remoteDataSource;
  final UserLocalDataSource userLocalDataSource;
  final NetworkInfo networkInfo;
  CarrierRepositoryImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.userLocalDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<Carrier>>> getRemoteCarriers() async {
    if (await networkInfo.isConnected) {
      if (await userLocalDataSource.isTokenAvailable()) {
        try {
          final String token = await userLocalDataSource.getToken();
          final result = await remoteDataSource.getCarriers(token);
          await localDataSource.saveCarriers(result);
          return right(result);
        } on Failure catch (failure) {
          print('Failure caught: $failure');
          return Left(failure);
        } catch (e) {
          print('Unexpected error: $e');
          return Left(ServerFailure()); // Or another custom failure
        }
      } else {
        print('Authentication failure: token not available.');
        return Left(AuthenticationFailure());
      }
    } else {
      print('Network failure: not connected.');
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Carrier>>> getCachedCarriers() async {
    try {
      final result = await localDataSource.getCarriers();
      return right(result);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  // @override
  // Future<Either<Failure, Carrier>> addCarrier( params) async {
  //   if (await networkInfo.isConnected) {
  //     if (await userLocalDataSource.isTokenAvailable()) {
  //       try {
  //         final String token = await userLocalDataSource.getToken();
  //         final result = await remoteDataSource.addCarrier(params, token);
  //         await localDataSource.updateCarrier(result);
  //         return right(result);
  //       } on Failure catch (failure) {
  //         print('Failure caught: $failure');
  //         return Left(failure);
  //       } catch (e) {
  //         print('Unexpected error: $e');
  //         return Left(ServerFailure()); // Or another custom failure
  //       }
  //     } else {
  //       print('Authentication failure: token not available.');
  //       return Left(AuthenticationFailure());
  //     }
  //   } else {
  //     print('Network failure: not connected.');
  //     return Left(NetworkFailure());
  //   }
  // }
  
  @override
  Future<Either<Failure, Carrier>> selectCarrier( Carrier params) async {
   try {
      final result = await localDataSource.updateSelectedCarrier(CarrierModel.fromEntity(params) );
      return right(params);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Carrier>> getSelectedCarrier() async {
    try {
      final result = await localDataSource.getSelectedCarrier();
      return right(result);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

}

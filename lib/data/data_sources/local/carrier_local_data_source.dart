import 'package:eshop/core/error/failures.dart';
import 'package:eshop/data/models/carrier_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CarrierLocalDataSource {
  Future<CarrierModel> getSelectedCarrier();
  Future<List<CarrierModel>> getCarriers();
  Future<void> saveCarriers(List<CarrierModel> params);
  Future<void> updateCarrier(CarrierModel params);
  Future<void> updateSelectedCarrier(CarrierModel params);
}

const cashedCarriers = 'CACHED_CARRIERS';
const cachedSelectedCarrier = 'CACHED_SELECTED_CARRIER';

class CarrierLocalDataSourceImpl implements CarrierLocalDataSource {
  final SharedPreferences sharedPreferences;
  CarrierLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CarrierModel>> getCarriers() {
    final jsonString = sharedPreferences.getString(cashedCarriers);
    if (jsonString != null) {
      return Future.value(carrierModelListFromLocalJson(jsonString));
    } else {
      throw CacheFailure();
    }
  }

  @override
  Future<void> saveCarriers(List<CarrierModel> params) {
    return sharedPreferences.setString(
      cashedCarriers,
      carrierModelListToJson(params),
    );
  }

  @override
  Future<void> updateCarrier(CarrierModel params) {
    final jsonString = sharedPreferences.getString(cashedCarriers);
    late List<CarrierModel> data;
    if (jsonString != null) {
      data = carrierModelListFromLocalJson(jsonString);
      if (data.any((carrier) => carrier == params)) {
        data[data.indexWhere((carrier) => carrier == params)] = params;
      } else {
        data.add(params);
      }
    } else {
      data = [params];
    }
    return sharedPreferences.setString(
      cashedCarriers,
      carrierModelListToJson(data),
    );
  }

  @override
  Future<CarrierModel> getSelectedCarrier() {
    final jsonString = sharedPreferences.getString(cachedSelectedCarrier);
    if (jsonString != null) {
      return Future.value(carrierModelFromLocalJson(jsonString));
    } else {
      throw CacheFailure();
    }
  }

  @override
  Future<void> updateSelectedCarrier(CarrierModel params) {
    return sharedPreferences.setString(
      cachedSelectedCarrier,
      carrierModelToJson(params),
    );
  }
}
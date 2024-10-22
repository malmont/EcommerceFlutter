import 'package:eshop/core/constant/strings.dart';
import 'package:eshop/core/error/exceptions.dart';
import 'package:eshop/data/models/carrier_model.dart';
import 'package:http/http.dart' as http;

abstract class CarrierRemoteDataSource {
  Future<List<CarrierModel>> getCarriers(String token);
}

class CarrierRemoteDataSourceImpl implements CarrierRemoteDataSource {
  final http.Client client;
  CarrierRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CarrierModel>> getCarriers(token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/Carrier'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return carrierModelListFromRemoteJson(response.body);
    } else {
      throw ServerException();
    }
  }
}

import 'package:eshop/core/error/failures.dart';
import 'package:eshop/data/models/order/order_detail_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer'; // Pour utiliser log()
import '../../../../core/error/exceptions.dart';
import '../../../core/constant/strings.dart';
import '../../models/order/order_details_model.dart';

abstract class OrderRemoteDataSource {
  Future<bool> addOrder(OrderDetailResponseModel params, String token);
  Future<List<OrderDetailsModel>> getOrders(String token);
}

class OrderRemoteDataSourceSourceImpl implements OrderRemoteDataSource {
  final http.Client client;
  OrderRemoteDataSourceSourceImpl({required this.client});

  @override
  Future<bool> addOrder(params, token) async {
    final response = await client.post(
      Uri.parse('$baseUrl/order/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: orderDetailResponseModelToJson(params),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<OrderDetailsModel>> getOrders(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/ordersuser'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      log('Response body: ${response.body}');

      try {
        return orderDetailsModelListFromJson(response.body);
      } catch (e) {
        log('Error during JSON deserialization: $e');
        throw ServerFailure();
      }
    } else {
      throw ServerFailure();
    }
  }
}

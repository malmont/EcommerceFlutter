import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../core/constant/strings.dart';
import '../../../domain/usecases/product/get_product_usecase.dart';
import '../../models/product/product_response_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductResponseModel> getProducts(FilterProductParams params);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductResponseModel> getProducts(FilterProductParams params) {
    final int page =
        params.limit != null && params.limit! > 0 ? params.limit! : 1;
    final int pageSize =
        params.pageSize != null && params.pageSize! > 0 ? params.pageSize! : 10;

    final categoriesParam = Uri.encodeComponent(
        jsonEncode(params.categories.map((e) => e.id).toList()));

    final url = '$baseUrl/products/by-category'
        '?keyword=${Uri.encodeComponent(params.keyword ?? '')}'
        '&page=$page'
        '&pageSize=$pageSize'
        '&categories=$categoriesParam';

    print('Requesting URL: $url');
    return _getProductFromUrl(url);
  }

  Future<ProductResponseModel> _getProductFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return productResponseModelFromJson(response.body);
    } else {
      throw ServerException();
    }
  }
}

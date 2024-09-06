import 'dart:convert';

import '../../../domain/entities/order/order_detail_response.dart';

OrderDetailResponseModel orderDetailResponseModelFromJson(String str) =>
    OrderDetailResponseModel.fromJson(json.decode(str));

String orderDetailResponseModelToJson(OrderDetailResponseModel data) =>
    json.encode(data.toJson());

class OrderDetailResponseModel extends OrderDetailResponse {
  const OrderDetailResponseModel({
    required int orderSource,
    required int paymentMethod,
    required int addressId,
    required int carrierId,
    required int typeOrder,
    required List<OrderItemDetailModel> items, // Modèle des items spécifiques
  }) : super(
          orderSource: orderSource,
          paymentMethod: paymentMethod,
          addressId: addressId,
          carrierId: carrierId,
          typeOrder: typeOrder,
          items: items,
        );

  factory OrderDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailResponseModel(
        orderSource: json["orderSource"],
        paymentMethod: json["paymentMethod"],
        addressId: json["addressId"],
        carrierId: json["carrierId"],
        typeOrder: json["typeOrder"],
        items: List<OrderItemDetailModel>.from(
            json["items"].map((x) => OrderItemDetailModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderSource": orderSource,
        "paymentMethod": paymentMethod,
        "addressId": addressId,
        "carrierId": carrierId,
        "typeOrder": typeOrder,
        "items": List<dynamic>.from(
            (items as List<OrderItemDetailModel>).map((item) => item.toJson())),
      };

  factory OrderDetailResponseModel.fromEntity(OrderDetailResponse entity) =>
      OrderDetailResponseModel(
        orderSource: entity.orderSource,
        paymentMethod: entity.paymentMethod,
        addressId: entity.addressId,
        carrierId: entity.carrierId,
        typeOrder: entity.typeOrder,
        items: entity.items
            .map((item) => OrderItemDetailModel.fromEntity(item))
            .toList(),
      );
}

class OrderItemDetailModel extends OrderItemDetail {
  const OrderItemDetailModel({
    required int productVariantId,
    required int quantity,
  }) : super(
          productVariantId: productVariantId,
          quantity: quantity,
        );

  factory OrderItemDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderItemDetailModel(
        productVariantId: json["productVariantId"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
        "quantity": quantity,
      };

  factory OrderItemDetailModel.fromEntity(OrderItemDetail entity) =>
      OrderItemDetailModel(
        productVariantId: entity.productVariantId,
        quantity: entity.quantity,
      );
}

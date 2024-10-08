import '../../../domain/entities/order/order_item.dart';
import '../product/price_tag_model.dart';
import '../product/product_model.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required String id,
    required ProductModel product,
    required num price,
    required num quantity,
  }) : super(
          id: id,
          product: product,
          price: price,
          quantity: quantity,
        );

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
      id: json["_id"],
      product: ProductModel.fromJson(json["product"]),
      price: json["price"],
      quantity: json["quantity"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "product": (product as ProductModel).toJson(),
        "price": price,
        "quantity": quantity,
      };

  Map<String, dynamic> toJsonBody() => {
        "_id": id,
        "product": product.id,
        "price": price,
        "quantity": quantity,
      };

  factory OrderItemModel.fromEntity(OrderItem entity) => OrderItemModel(
        id: entity.id,
        product: ProductModel.fromEntity(entity.product),
        price: entity.price,
        quantity: entity.quantity,
      );
}

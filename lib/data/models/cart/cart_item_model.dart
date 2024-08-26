import 'dart:convert';

import 'package:eshop/domain/entities/product/product.dart';

import '../../../domain/entities/cart/cart_item.dart';
import '../product/product_model.dart';

List<CartItemModel> cartItemModelListFromLocalJson(String str) =>
    List<CartItemModel>.from(
        json.decode(str).map((x) => CartItemModel.fromJson(x)));

List<CartItemModel> cartItemModelListFromRemoteJson(String str) =>
    List<CartItemModel>.from(
        json.decode(str)["data"].map((x) => CartItemModel.fromJson(x)));

List<CartItemModel> cartItemModelFromJson(String str) =>
    List<CartItemModel>.from(
        json.decode(str).map((x) => CartItemModel.fromJson(x)));

String cartItemModelToJson(List<CartItemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class CartItemModel extends CartItem {
  const CartItemModel({
    String? id,
    required ProductModel product,
    int quantity = 1,
  }) : super(id: id, product: product, quantity: quantity);

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json["_id"],
      product: ProductModel.fromJson(json["product"]),
      quantity: json["quantity"] ?? 1,  // Assuming quantity is part of the JSON response
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "product": (product as ProductModel).toJson(),
        "quantity": quantity,
      };

  Map<String, dynamic> toBodyJson() => {
        "_id": id,
        "product": product.id,
        "quantity": quantity,
      };

  factory CartItemModel.fromParent(CartItem cartItem) {
    return CartItemModel(
      id: cartItem.id,
      product: cartItem.product is ProductModel
          ? cartItem.product as ProductModel
          : ProductModel.fromEntity(cartItem.product),
      quantity: cartItem.quantity,
    );
  }

  @override
  CartItemModel copyWith({
    String? id,
    Product? product,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product is ProductModel ? product : this.product as ProductModel,
      quantity: quantity ?? this.quantity,
    );
  }
}

import 'dart:convert';

import 'package:eshop/data/models/variant_model.dart';
import 'package:eshop/domain/entities/product/product.dart';
import 'package:eshop/domain/entities/product/variant.dart';

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
    required VariantModel variant,
  }) : super(id: id, product: product, quantity: quantity, variant: variant);

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      variant: VariantModel.fromJson(json["variant"]),
      id: json["_id"],
      product: ProductModel.fromJson(json["product"]),
      quantity: json["quantity"] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        "variant": (variant as VariantModel).toJson(),
        "_id": id,
        "product": (product as ProductModel).toJson(),
        "quantity": quantity,
      };

  Map<String, dynamic> toBodyJson() => {
        "variant": (variant as VariantModel).toJson(),
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
      variant: cartItem.variant is VariantModel
          ? cartItem.variant as VariantModel
          : VariantModel.fromEntity(cartItem.variant),
    );
  }

  @override
  CartItemModel copyWith({
    String? id,
    Product? product, // Utilisation du type générique Product
    int? quantity,
    Variant? variant, // Utilisation du type générique Variant
  }) {
    return CartItemModel(
      variant: variant is VariantModel
          ? variant
          : VariantModel.fromEntity(variant ?? this.variant), // Conversion en VariantModel si nécessaire
      id: id ?? this.id,
      product: product is ProductModel
          ? product
          : ProductModel.fromEntity(product ?? this.product), // Conversion en ProductModel si nécessaire
      quantity: quantity ?? this.quantity,
    );
  }
}

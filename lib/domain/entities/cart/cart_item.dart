import 'package:equatable/equatable.dart';
import 'package:eshop/domain/entities/product/variant.dart';
import '../product/product.dart';

class CartItem extends Equatable {
  final String? id;
  final Product product;
  final int quantity;
  final Variant variant;

  const CartItem({this.id, required this.product, this.quantity = 1, required this.variant});

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
     Variant? variant,
  }) {
    return CartItem(
      variant:variant ?? this.variant,
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, product, quantity, variant];
}

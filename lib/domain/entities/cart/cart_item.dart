import 'package:equatable/equatable.dart';
import '../product/product.dart';

class CartItem extends Equatable {
  final String? id;
  final Product product;
  final int quantity;

  const CartItem({this.id, required this.product, this.quantity = 1});

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, product, quantity];
}

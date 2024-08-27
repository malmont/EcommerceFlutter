part of 'cart_bloc.dart';
abstract class CartState extends Equatable {
  final List<CartItem> cart;
  final int totalItems;

  const CartState({required this.cart, required this.totalItems});
}

class CartInitial extends CartState {
  const CartInitial({required List<CartItem> cart, required int totalItems}) : super(cart: cart, totalItems: totalItems);

  @override
  List<Object> get props => [cart, totalItems];
}

class CartLoading extends CartState {
  const CartLoading({required List<CartItem> cart, required int totalItems}) : super(cart: cart, totalItems: totalItems);

  @override
  List<Object> get props => [cart, totalItems];
}

class CartLoaded extends CartState {
  const CartLoaded({required List<CartItem> cart, required int totalItems}) : super(cart: cart, totalItems: totalItems);

  @override
  List<Object> get props => [cart, totalItems];
}

class CartError extends CartState {
  final Failure failure;

  const CartError({required List<CartItem> cart, required this.failure, required int totalItems}) : super(cart: cart, totalItems: totalItems);

  @override
  List<Object> get props => [cart, failure, totalItems];
}


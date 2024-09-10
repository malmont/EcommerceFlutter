part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class GetProducts extends ProductEvent {
  final FilterProductParams params;
  const GetProducts(this.params);

  @override
  List<Object> get props => [];
}

class GetMoreProducts extends ProductEvent {
  const GetMoreProducts();
  @override
  List<Object> get props => [];
}

class SelectVariantEvent extends ProductEvent {
  final String color;
  final String size;
  final String productId; // Ajoute l'ID du produit

  const SelectVariantEvent({
    required this.color,
    required this.size,
    required this.productId, // Requis pour l'événement
  });

  @override
  List<Object> get props => [color, size, productId];
}
class ResetVariantEvent extends ProductEvent {
  const ResetVariantEvent();

  @override
  List<Object> get props => [];
}
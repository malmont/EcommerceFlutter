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

  const SelectVariantEvent({required this.color, required this.size});


  @override
  List<Object> get props => [color, size];
}

class ResetVariantEvent extends ProductEvent {
  const ResetVariantEvent();

  @override
  List<Object> get props => [];
}
part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  final List<Product> products;
  final PaginationMetaData metaData;
  final FilterProductParams params;
  final Variant? selectedVariant;  // Ajout de la gestion du variant sélectionné

  const ProductState({
    required this.products,
    required this.metaData,
    required this.params,
    this.selectedVariant,  // Le variant sélectionné est optionnel
  });

  @override
  List<Object?> get props => [products, metaData, params, selectedVariant];
}

class ProductInitial extends ProductState {
  const ProductInitial({
    required super.products,
    required super.metaData,
    required super.params,
  });
}

class ProductEmpty extends ProductState {
  const ProductEmpty({
    required super.products,
    required super.metaData,
    required super.params,
  });
}

class ProductLoading extends ProductState {
  const ProductLoading({
    required super.products,
    required super.metaData,
    required super.params,
    Variant? selectedVariant,  // Conserver l'état du variant sélectionné pendant le chargement
  }) : super(selectedVariant: selectedVariant);  // Passer directement le variant
}

class ProductLoaded extends ProductState {
  const ProductLoaded({
    required super.products,
    required super.metaData,
    required super.params,
    Variant? selectedVariant,  // Inclure le variant sélectionné dans l'état ProductLoaded
  }) : super(selectedVariant: selectedVariant);  // Pas besoin de passer "products" deux fois
}

class ProductError extends ProductState {
  final Failure failure;
  const ProductError({
    required super.products,
    required super.metaData,
    required super.params,
    required this.failure,
    Variant? selectedVariant,  // Conserver l'état du variant sélectionné lors d'une erreur
  }) : super(selectedVariant: selectedVariant);

  @override
  List<Object> get props => [failure];
}

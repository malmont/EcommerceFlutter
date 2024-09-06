import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eshop/domain/entities/product/variant.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/product/pagination_meta_data.dart';
import '../../../domain/entities/product/product.dart';
import '../../../domain/usecases/product/get_product_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUseCase _getProductUseCase;
  int currentPage = 1; // Suivi de la page actuelle
  bool isFetching = false; // Empêcher les requêtes multiples

  ProductBloc(this._getProductUseCase)
      : super(ProductInitial(
          products: const [],
          params: const FilterProductParams(),
          metaData: PaginationMetaData(
            pageSize: 20,
            limit: 0,
            total: 0,
          ),
        )) {
    on<GetProducts>(_onLoadProducts);
    on<GetMoreProducts>(_onLoadMoreProducts);
    on<SelectVariantEvent>(_onSelectVariant);
    on<ResetVariantEvent>(_onResetVariant);
  }

  // Chargement initial des produits
  void _onLoadProducts(GetProducts event, Emitter<ProductState> emit) async {
    currentPage = 1; // Réinitialiser la page à 1 lors d'un nouveau chargement
    isFetching = true; // Empêcher d'autres requêtes pendant le chargement
    try {
      emit(ProductLoading(
        products: const [],
        metaData: state.metaData,
        params: event.params,
      ));

      final result = await _getProductUseCase(event.params.copyWith(
              limit: currentPage) // Utiliser currentPage comme limite/page
          );

      result.fold(
        (failure) {
          isFetching = false;
          emit(ProductError(
            products: state.products,
            metaData: state.metaData,
            failure: failure,
            params: event.params,
          ));
        },
        (productResponse) {
          currentPage++; // Incrémenter la page après un chargement réussi
          isFetching = false;
          emit(ProductLoaded(
            metaData: productResponse.paginationMetaData,
            products: productResponse.products,
            params: event.params.copyWith(limit: currentPage),
          ));
        },
      );
    } catch (e) {
      isFetching = false;
      emit(ProductError(
        products: state.products,
        metaData: state.metaData,
        failure: ExceptionFailure(),
        params: event.params,
      ));
    } finally {
      // S'assurer que isFetching est réinitialisé en cas de succès ou d'échec
      isFetching = false;
    }
  }

  // Chargement des produits supplémentaires lors du défilement
  void _onLoadMoreProducts(
      GetMoreProducts event, Emitter<ProductState> emit) async {
    var state = this.state;

    // Empêcher de charger plus de produits si un chargement est en cours
    if (state is ProductLoaded && !isFetching) {
      var total = state.metaData.total;
      var loadedProductsLength = state.products.length;

      // Si le nombre de produits chargés est inférieur au total, continuer le chargement
      if (loadedProductsLength < total) {
        isFetching = true;
        try {
          // Émettre un état ProductLoading, mais garder les produits existants
          emit(ProductLoading(
            products: state.products,
            metaData: state.metaData,
            params: state.params,
          ));

          // Charger la page suivante en utilisant currentPage
          final result = await _getProductUseCase(
            state.params.copyWith(
                limit: currentPage), // Utiliser currentPage pour la pagination
          );

          result.fold(
            (failure) {
              isFetching = false;
              emit(ProductError(
                products: state.products,
                metaData: state.metaData,
                failure: failure,
                params: state.params,
              ));
            },
            (productResponse) {
              List<Product> updatedProducts = List.from(state.products)
                ..addAll(productResponse.products);

              currentPage++; // Incrémenter la page pour la prochaine requête
              emit(ProductLoaded(
                metaData: productResponse.paginationMetaData,
                products: updatedProducts,
                params: state.params
                    .copyWith(limit: currentPage), // Mettre à jour la page
              ));
            },
          );
        } catch (e) {
          emit(ProductError(
            products: state.products,
            metaData: state.metaData,
            failure: ExceptionFailure(),
            params: state.params,
          ));
        } finally {
          isFetching = false; // Réinitialiser après le chargement
        }
      }
    }
  }

  void _onSelectVariant(SelectVariantEvent event, Emitter<ProductState> emit) {
    final state = this.state;
    if (state is ProductLoaded) {
      // Rechercher le variant sélectionné
      final Variant selectedVariant =
          state.products.expand((product) => product.variants).firstWhere(
                (variant) =>
                    variant.color.name == event.color &&
                    variant.size.name == event.size,
                orElse: () => throw Exception(
                    'Variant not found'), // Lever une exception si aucun variant n'est trouvé
              );

      // Mettre à jour l'état avec le variant sélectionné
      emit(ProductLoaded(
        products: state.products,
        params: state.params,
        metaData: state.metaData,
        selectedVariant: selectedVariant, // Le variant trouvé est passé ici
      ));
    }
  }

  void _onResetVariant(ResetVariantEvent event, Emitter<ProductState> emit) {
    final state = this.state;
    if (state is ProductLoaded) {
      emit(ProductLoaded(
        products: state.products,
        params: state.params,
        metaData: state.metaData,
        selectedVariant: null,
      ));
    }
  }
}

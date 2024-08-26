import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eshop/domain/usecases/cart/remove_cart_usecase.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/cart/cart_item.dart';
import '../../../domain/usecases/cart/add_cart_item_usecase.dart';
import '../../../domain/usecases/cart/clear_cart_usecase.dart';
import '../../../domain/usecases/cart/get_cached_cart_usecase.dart';
import '../../../domain/usecases/cart/sync_cart_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCachedCartUseCase _getCachedCartUseCase;
  final AddCartUseCase _addCartUseCase;
  final SyncCartUseCase _syncCartUseCase;
  final ClearCartUseCase _clearCartUseCase;
  final RemoveCartUseCase _removeCartUseCase;

  CartBloc(
    this._getCachedCartUseCase,
    this._addCartUseCase,
    this._syncCartUseCase,
    this._clearCartUseCase,
    this._removeCartUseCase,
  ) : super(const CartInitial(cart: [])) {
    on<GetCart>(_onGetCart);
    on<AddProduct>(_onAddToCart);
    on<RemoveProduct>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  void _onGetCart(GetCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading(cart: state.cart));
      final result = await _getCachedCartUseCase(NoParams());
      result.fold(
        (failure) => emit(CartError(cart: state.cart, failure: failure)),
        (cart) => emit(CartLoaded(cart: cart)),
      );
      final syncResult = await _syncCartUseCase(NoParams());
      emit(CartLoading(cart: state.cart));
      syncResult.fold(
        (failure) => emit(CartError(cart: state.cart, failure: failure)),
        (cart) => emit(CartLoaded(cart: cart)),
      );
    } catch (e) {
      emit(CartError(failure: ExceptionFailure(), cart: state.cart));
    }
  }
void _onAddToCart(AddProduct event, Emitter<CartState> emit) async {
  try {
    emit(CartLoading(cart: state.cart));

    // Appel du use case pour ajouter l'item au panier
    final result = await _addCartUseCase(event.cartItem);

    await result.fold(
      (failure) async {
        emit(CartError(cart: state.cart, failure: failure));
      },
      (_) async {
        // Récupérer la dernière version du panier après ajout
        final updatedCartItems = await _getCachedCartUseCase(NoParams());
        updatedCartItems.fold(
          (failure) => emit(CartError(cart: state.cart, failure: failure)),
          (cartItems) {
            emit(CartLoaded(cart: cartItems));
          },
        );
      },
    );
  } catch (e) {
    emit(CartError(cart: state.cart, failure: ExceptionFailure()));
  }
}



void _onRemoveFromCart(RemoveProduct event, Emitter<CartState> emit) async {
  try {
    emit(CartLoading(cart: state.cart));

    final result = await _removeCartUseCase(event.cartItem);

    result.fold(
      (failure) => emit(CartError(cart: state.cart, failure: failure)),
      (_) {
        final updatedCart = List<CartItem>.from(state.cart);
        final existingItemIndex = updatedCart.indexWhere(
          (item) => item.product.id == event.cartItem.product.id,
        );

        if (existingItemIndex != -1) {
          final existingItem = updatedCart[existingItemIndex];
          if (existingItem.quantity > 1) {
            updatedCart[existingItemIndex] = existingItem.copyWith(
              quantity: existingItem.quantity - 1,
            );
          } else {
            updatedCart.removeAt(existingItemIndex);
          }
        }

        emit(CartLoaded(cart: updatedCart));
      },
    );
  } catch (e) {
    emit(CartError(cart: state.cart, failure: ExceptionFailure()));
  }
}


  void _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      emit(const CartLoading(cart: []));
      emit(const CartLoaded(cart: []));
      await _clearCartUseCase(NoParams());
    } catch (e) {
      emit(CartError(cart: const [], failure: ExceptionFailure()));
    }
  }
}

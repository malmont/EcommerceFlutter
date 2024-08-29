import 'package:eshop/core/error/failures.dart';
import 'package:eshop/domain/entities/cart/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/cart/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCart();
  Future<void> saveCart(List<CartItemModel> cart);
  Future<void> saveCartItem(CartItemModel cartItem);
  Future<bool> clearCart();
  Future<void> updateCart(List<CartItem> cart);
}

const cachedCart = 'CACHED_CART';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveCart(List<CartItemModel> cart) {
    return sharedPreferences.setString(
      cachedCart,
      cartItemModelToJson(cart),
    );
  }

  @override
Future<void> updateCart(List<CartItem> cartItems) async {
  final List<CartItemModel> cartModels = cartItems
      .map((item) => CartItemModel.fromParent(item))
      .toList();

  // Attendre que setString soit terminé, mais ne rien retourner
  await sharedPreferences.setString(
    cachedCart,
    cartItemModelToJson(cartModels),
  );
}

@override
Future<void> saveCartItem(CartItemModel cartItem) async {
  final jsonString = sharedPreferences.getString(cachedCart);
  final List<CartItemModel> cart = [];
  if (jsonString != null) {
    cart.addAll(cartItemModelListFromLocalJson(jsonString));
  }
  
  final existingItemIndex = cart.indexWhere(
      (element) => element.product.id == cartItem.product.id);

  if (existingItemIndex != -1) {
    // Le produit existe déjà, on incrémente la quantité
    final existingItem = cart[existingItemIndex];
    cart[existingItemIndex] = existingItem.copyWith(
      quantity: existingItem.quantity + 1,
    );
  } else {
    // Le produit n'existe pas, on l'ajoute
    cart.add(cartItem);
  }

  await sharedPreferences.setString(
    cachedCart,
    cartItemModelToJson(cart),
  );
}



  @override
Future<List<CartItemModel>> getCart() async {
  final jsonString = sharedPreferences.getString(cachedCart);
  if (jsonString != null) {
    return Future.value(cartItemModelListFromLocalJson(jsonString));
  } else {
    return Future.value([]);
  }
}

  @override
  Future<bool> clearCart()async {
    return sharedPreferences.remove(cachedCart);
  }
}

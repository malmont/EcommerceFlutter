import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/cart/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../data_sources/local/cart_local_data_source.dart';
import '../data_sources/local/user_local_data_source.dart';
import '../data_sources/remote/cart_remote_data_source.dart';
import '../models/cart/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;
  final UserLocalDataSource userLocalDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.userLocalDataSource,
    required this.networkInfo,
  }); 

@override
Future<Either<Failure, CartItem>> addToCart(CartItem params) async {
  try {
    // Récupérer le panier actuel (ou une liste vide si aucun enregistrement n'est trouvé)
    final List<CartItemModel> cartItems = await localDataSource.getCart();
    
    // Vérifier si le produit existe déjà dans le panier
    final existingItemIndex = cartItems.indexWhere(
      (item) => item.product.id == params.product.id,
    );

    if (existingItemIndex != -1) {
      // Le produit existe déjà, on incrémente la quantité
      final existingItem = cartItems[existingItemIndex];
      cartItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // Le produit n'existe pas, on l'ajoute
      cartItems.add(CartItemModel.fromParent(params));
    }

    // Sauvegarde locale après la mise à jour du panier
    await localDataSource.saveCart(cartItems);

    if (await userLocalDataSource.isTokenAvailable()) {
      final String token = await userLocalDataSource.getToken();
      final remoteProduct = await remoteDataSource.addToCart(
        CartItemModel.fromParent(params),
        token,
      );
      return Right(remoteProduct);
    } else {
      return Right(params);
    }
  } catch (e) {
    // En cas d'erreur, renvoyer un échec de cache
    return Left(CacheFailure());
  }
}
@override
  Future<Either<Failure, void>> removeFromCart(CartItem params) async {
    try {
      final List<CartItemModel> cartItems = await localDataSource.getCart();
      
      final existingItemIndex = cartItems.indexWhere(
        (item) => item.product.id == params.product.id,
      );

      if (existingItemIndex != -1) {
        final existingItem = cartItems[existingItemIndex];
        if (existingItem.quantity > 1) {
          cartItems[existingItemIndex] = existingItem.copyWith(
            quantity: existingItem.quantity - 1,
          );
        } else {
          cartItems.removeAt(existingItemIndex);
        }

        // Sauvegarde locale après la suppression
        await localDataSource.saveCart(cartItems);

        if (await userLocalDataSource.isTokenAvailable()) {
          final String token = await userLocalDataSource.getToken();
          await remoteDataSource.removeFromCart(
            CartItemModel.fromParent(params),
            token,
          );
        }

        return const Right(null);
      } else {
        return Left(CacheFailure());
      }
    } catch (e) {
      return Left(CacheFailure());
    }
  }


  @override
  Future<Either<Failure, List<CartItem>>> getCachedCart() async {
    try {
      final localProducts = await localDataSource.getCart();
      return Right(localProducts);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> syncCart() async {
    if (await networkInfo.isConnected) {
      if (await userLocalDataSource.isTokenAvailable()) {
        List<CartItemModel> localCartItems = [];
        try {
          localCartItems = await localDataSource.getCart();
        } on Failure catch (_) {}
        try {
          final String token = await userLocalDataSource.getToken();
          final syncedResult = await remoteDataSource.syncCart(
            localCartItems,
            token,
          );
          await localDataSource.saveCart(syncedResult);
          return Right(syncedResult);
        } on Failure catch (failure) {
          return Left(failure);
        }
      } else {
        return Left(NetworkFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> clearCart() async {
    bool result = await localDataSource.clearCart();
    if (result) {
      return Right(result);
    } else {
      return Left(CacheFailure());
    }
  }
}

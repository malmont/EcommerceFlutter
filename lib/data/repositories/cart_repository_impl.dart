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
      final List<CartItemModel> cartItems = await localDataSource.getCart();
      
      // Comparer à la fois product.id et variant.id pour identifier un élément unique
      final existingItemIndex = cartItems.indexWhere(
        (item) => item.product.id == params.product.id && item.variant.id == params.variant.id,
      );

      if (existingItemIndex != -1) {
        final existingItem = cartItems[existingItemIndex];
        cartItems[existingItemIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + 1,
        );
      } else {
        cartItems.add(CartItemModel.fromParent(params));
      }
      await localDataSource.saveCart(cartItems);
      return Right(params);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(CartItem params) async {
    try {
      final List<CartItemModel> cartItems = await localDataSource.getCart();
      
      // Comparer à la fois product.id et variant.id pour identifier un élément unique
      final existingItemIndex = cartItems.indexWhere(
        (item) => item.product.id == params.product.id && item.variant.id == params.variant.id,
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

        await localDataSource.saveCart(cartItems);

        // if (await userLocalDataSource.isTokenAvailable()) {
        //   final String token = await userLocalDataSource.getToken();
        //   await remoteDataSource.removeFromCart(
        //     CartItemModel.fromParent(params),
        //     token,
        //   );
        // }

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
    } catch (failure) {
      return Left(CacheFailure());
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
        } on Failure catch (failure){
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
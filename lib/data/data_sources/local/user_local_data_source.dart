import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../models/user/user_model.dart';
import 'cart_local_data_source.dart';

abstract class UserLocalDataSource {
  Future<String> getToken();

  Future<UserModel> getUser();

  Future<void> saveToken(String token);

  Future<void> saveUser(UserModel user);

  Future<void> clearCache();

  Future<bool> isTokenAvailable();
}

const cachedToken = 'TOKEN';
const cachedUser = 'USER';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;
  UserLocalDataSourceImpl(
      {required this.sharedPreferences, required this.secureStorage});

  @override
  Future<String> getToken() async {
    String? token = await secureStorage.read(key: cachedToken);
    if (token != null) {
      return Future.value(token);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: cachedToken, value: token);
  }

  @override
  Future<UserModel> getUser() async {
    if (sharedPreferences.getBool('first_run') ?? true) {
      await secureStorage.deleteAll();
      sharedPreferences.setBool('first_run', false);
    }
    final jsonString = sharedPreferences.getString(cachedUser);
    if (jsonString != null) {
      return Future.value(userModelFromJson(jsonString));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> saveUser(UserModel user) {
    return sharedPreferences.setString(
      cachedUser,
      userModelToJson(user),
    );
  }

  @override
  Future<bool> isTokenAvailable() async {
    String? token = await secureStorage.read(key: cachedToken);
    if (token != null) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        int? expirationTime = decodedToken['exp'];
        if (expirationTime != null) {
          DateTime expirationDate =
              DateTime.fromMillisecondsSinceEpoch(expirationTime * 1000);
          if (expirationDate.isBefore(DateTime.now())) {
            await secureStorage.delete(key: cachedToken);
            return Future.value(false);
          }
          return Future.value(true);
        }
      } catch (e) {
        await secureStorage.delete(key: cachedToken);
        return Future.value(false);
      }
    }
    return Future.value(false);
  }

  @override
  Future<void> clearCache() async {
    await secureStorage.deleteAll();
    await sharedPreferences.remove(cachedCart);
    await sharedPreferences.remove(cachedUser);
  }
}

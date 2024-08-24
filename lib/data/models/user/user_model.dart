import 'dart:convert';

import '../../../domain/entities/user/user.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends User {
  const UserModel({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
  }) : super(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"].toString(),  // Modification ici pour utiliser "id" au lieu de "_id"
    firstName: json["firstName"] ?? '', // Gestion des valeurs nulles
    lastName: json["lastName"] ?? '',   // Gestion des valeurs nulles
    email: json["email"] ?? '',         // Gestion des valeurs nulles
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
  };
}

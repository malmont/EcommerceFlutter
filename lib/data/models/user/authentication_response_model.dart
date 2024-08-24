import 'dart:convert';
import 'user_model.dart';

AuthenticationResponseModel authenticationResponseModelFromJson(String str) =>
    AuthenticationResponseModel.fromJson(json.decode(str));

String authenticationResponseModelToJson(AuthenticationResponseModel data) =>
    json.encode(data.toJson());

class AuthenticationResponseModel {
  final String token;
  final UserModel user;

  const AuthenticationResponseModel({
    required this.token,
    required this.user,
  });

  factory AuthenticationResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthenticationResponseModel(
        token: json["token"],  // Extraction du token à partir du JSON
        user: _decodeUserFromToken(json["token"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
      };

static UserModel _decodeUserFromToken(String token) {
  try {
    final decodedPayload = _parseJwt(token);

    print('Payload: $decodedPayload'); // Affiche le payload pour débogage

    final firstName = decodedPayload['firstName'] as String? ?? '';
    final lastName = decodedPayload['lastName'] as String? ?? '';
    final email = decodedPayload['email'] as String? ?? '';

    return UserModel.fromJson({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
    });
  } catch (e) {
    print('Error during token decoding: $e'); // Capture et affiche l'erreur
    rethrow; // Relance l'erreur après l'avoir affichée
  }
}


 static Map<String, dynamic> _parseJwt(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);

    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid payload');
    }

    return payloadMap;
  } catch (e) {
    print('Error during JWT parsing: $e');
    rethrow;
  }
}

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }
    return utf8.decode(base64Url.decode(output));
  }
}

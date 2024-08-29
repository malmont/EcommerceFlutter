import 'dart:convert';

import '../../../domain/entities/carrier.dart';


List<CarrierModel> carrierModelListFromRemoteJson(String str) =>
    List<CarrierModel>.from(json.decode(str).map((x) => CarrierModel.fromJson(x)));

List<CarrierModel> carrierModelListFromLocalJson(String str) =>
    List<CarrierModel>.from(json.decode(str).map((x) => CarrierModel.fromJson(x)));

CarrierModel carrierModelFromLocalJson(String str) =>
    CarrierModel.fromJson(json.decode(str));

String carrierModelToJson(CarrierModel data) => json.encode(data.toJson());  

String carrierModelListToJson(List<CarrierModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


CarrierModel carrierModelFromRemoteJson(String str) =>
    CarrierModel.fromJson(json.decode(str));

class CarrierModel extends Carrier {
  const CarrierModel({
  required String id,
  required String name,
  required String photo,
  required String description,
  required int price,
  }) : super(
        id: id,
        name: name,
        photo: photo,
        description: description,
        price: price,
        );

  factory CarrierModel.fromJson(Map<String, dynamic> json) => CarrierModel(
        id: json["id"].toString(),
        name: json["name"],
        photo: json["photo"],
        description: json["description"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photo": photo,
        "price": price,
      };

      factory CarrierModel.fromEntity(Carrier entity) => CarrierModel(
      id: entity.id,
      name: entity.name,
      photo: entity.photo,
      description: entity.description,
      price: entity.price,
    );
    
}



import 'dart:convert';
import '../../../domain/entities/category/category.dart';


   List<CategoryModel> categoryModelListFromRemoteJson(String str) =>
      List<CategoryModel>.from(
          json.decode(str).map((x) => CategoryModel.fromJson(x)));

   List<CategoryModel> categoryModelListFromLocalJson(String str) =>
      List<CategoryModel>.from(
          json.decode(str).map((x) => CategoryModel.fromJson(x)));

   String categoryModelListToJson(List<CategoryModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class CategoryModel extends Category {
  const CategoryModel({
    required int id,
    required String name,
    required String description,
    required String image,
  }) : super(
          id: id,
          name: name,
          description: description,
          image: image,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": image,
      };

  factory CategoryModel.fromEntity(Category entity) => CategoryModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        image: entity.image,
      );

}

import '../../../domain/entities/product/size.dart';

class SizeModel extends Size {
  const SizeModel({
    required int id,
    required String name,
  }) : super(
          id: id,
          name: name,
        );

  factory SizeModel.fromJson(Map<String, dynamic> json) => SizeModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  factory SizeModel.fromEntity(Size entity) => SizeModel(
        id: entity.id,
        name: entity.name,
      );
}
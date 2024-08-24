import '../../../domain/entities/product/style.dart';

class StyleModel extends Style {
  const StyleModel({
    required int id,
    required String name,
  }) : super(
          id: id,
          name: name,
        );

  factory StyleModel.fromJson(Map<String, dynamic> json) => StyleModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  factory StyleModel.fromEntity(Style entity) => StyleModel(
        id: entity.id,
        name: entity.name,
      );
}

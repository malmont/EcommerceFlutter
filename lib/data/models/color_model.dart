import '../../../domain/entities/product/color.dart';

class ColorModel extends Color {
  const ColorModel({
    required int id,
    required String name,
    required String codeHexa,
  }) : super(
          id: id,
          name: name,
          codeHexa: codeHexa,
        );

  factory ColorModel.fromJson(Map<String, dynamic> json) => ColorModel(
        id: json["id"],
        name: json["name"],
        codeHexa: json["codeHexa"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "codeHexa": codeHexa,
      };

  factory ColorModel.fromEntity(Color entity) => ColorModel(
        id: entity.id,
        name: entity.name,
        codeHexa: entity.codeHexa,
      );
}
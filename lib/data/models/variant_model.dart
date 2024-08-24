

import 'color_model.dart';
import 'size_model.dart';

import '../../../domain/entities/product/variant.dart';

class VariantModel extends Variant {
  final ColorModel color; // Utilisation de ColorModel ici
  final SizeModel size;   // Utilisation de SizeModel ici

  VariantModel({
    required int id,
    required this.color,
    required this.size,
    required int stockQuantity,
  }) : super(
          id: id,
          color: color,
          size: size,
          stockQuantity: stockQuantity,
        );

  factory VariantModel.fromJson(Map<String, dynamic> json) => VariantModel(
        id: json["id"],
        color: ColorModel.fromJson(json["color"]),
        size: SizeModel.fromJson(json["size"]),
        stockQuantity: json["stockQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "color": color.toJson(),
        "size": size.toJson(), // Appel de toJson sur SizeModel
        "stockQuantity": stockQuantity,
      };

  factory VariantModel.fromEntity(Variant entity) => VariantModel(
        id: entity.id,
        color: ColorModel.fromEntity(entity.color),
        size: SizeModel.fromEntity(entity.size), // Conversion en SizeModel
        stockQuantity: entity.stockQuantity,
      );
}

import 'package:eshop/data/models/style_model.dart';
import 'package:eshop/data/models/variant_model.dart';
import '../../../domain/entities/product/product.dart';
import '../category/category_model.dart';

class ProductModel extends Product {
  const ProductModel({
    required String id,
    required String name,
    required String description,
    String? moreInformations,
    required int price,
    required int purchasePrice,
    required int coefficientMultiplier,
    String? barcode,
    required bool isBestseller,
    required bool isNewArrival,
    required bool isFeatured,
    required bool isSpecialOffer,
    required String image,
    required int quantity,
    required DateTime createdAt,
    String? tags,
    required String slug,
    required StyleModel style,
    required List<VariantModel> variants,
    required List<CategoryModel> category,
  }) : super(
          id: id,
          name: name,
          description: description,
          moreInformations: moreInformations,
          price: price,
          purchasePrice: purchasePrice,
          coefficientMultiplier: coefficientMultiplier,
          barcode: barcode,
          isBestseller: isBestseller,
          isNewArrival: isNewArrival,
          isFeatured: isFeatured,
          isSpecialOffer: isSpecialOffer,
          image: image,
          quantity: quantity,
          createdAt: createdAt,
          tags: tags,
          slug: slug,
          style: style,
          variants: variants,
          category: category,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"].toString(),
        name: json["name"],
        description: json["description"],
        moreInformations: json["moreinformations"],
        price: json["price"],
        purchasePrice: json["purchasePrice"],
        coefficientMultiplier: json["coefficientMultiplier"],
        barcode: json["barcode"],
        isBestseller: json["isbestseller"],
        isNewArrival: json["isnewarrival"],
        isFeatured: json["isfeatured"],
        isSpecialOffer: json["isspecialoffer"],
        image: json["image"],
        quantity: json["quantity"],
        createdAt: DateTime.parse(json["createdAt"]),
        tags: json["tags"],
        slug: json["slug"],
        style: StyleModel.fromJson(json["style"]),
        variants: List<VariantModel>.from(
            json["variants"].map((x) => VariantModel.fromJson(x))),
        category: List<CategoryModel>.from(
            json["category"].map((x) => CategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "moreinformations": moreInformations,
        "price": price,
        "purchasePrice": purchasePrice,
        "coefficientMultiplier": coefficientMultiplier,
        "barcode": barcode,
        "isbestseller": isBestseller,
        "isnewarrival": isNewArrival,
        "isfeatured": isFeatured,
        "isspecialoffer": isSpecialOffer,
        "image": image,
        "quantity": quantity,
        "createdAt": createdAt.toIso8601String(),
        "tags": tags,
        "slug": slug,
        "style": style.toJson(),
        "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
        "category": List<dynamic>.from(category.map((x) => x.toJson())),
      };

  factory ProductModel.fromEntity(Product entity) => ProductModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        moreInformations: entity.moreInformations,
        price: entity.price,
        purchasePrice: entity.purchasePrice,
        coefficientMultiplier: entity.coefficientMultiplier,
        barcode: entity.barcode,
        isBestseller: entity.isBestseller,
        isNewArrival: entity.isNewArrival,
        isFeatured: entity.isFeatured,
        isSpecialOffer: entity.isSpecialOffer,
        image: entity.image,
        quantity: entity.quantity,
        createdAt: entity.createdAt,
        tags: entity.tags,
        slug: entity.slug,
        style: StyleModel.fromEntity(entity.style),
        variants: entity.variants
            .map((variant) => VariantModel.fromEntity(variant))
            .toList(),
        category: entity.category
            .map((category) => CategoryModel.fromEntity(category))
            .toList(),
      );
}

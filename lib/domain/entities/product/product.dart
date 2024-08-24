import 'package:equatable/equatable.dart';
import 'package:eshop/domain/entities/product/style.dart';
import 'package:eshop/domain/entities/product/variant.dart';
import '../category/category.dart';


class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? moreInformations;
  final int price;
  final int purchasePrice;
  final int coefficientMultiplier;
  final String? barcode;
  final bool isBestseller;
  final bool isNewArrival;
  final bool isFeatured;
  final bool isSpecialOffer;
  final String image;
  final int quantity;
  final DateTime createdAt;
  final String? tags;
  final String slug;
  final Style style;
  final List<Variant> variants;
  final List<Category> category;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    this.moreInformations,
    required this.price,
    required this.purchasePrice,
    required this.coefficientMultiplier,
    this.barcode,
    required this.isBestseller,
    required this.isNewArrival,
    required this.isFeatured,
    required this.isSpecialOffer,
    required this.image,
    required this.quantity,
    required this.createdAt,
    this.tags,
    required this.slug,
    required this.style,
    required this.variants,
    required this.category,
  });

  @override
  List<Object?> get props => [id];
}

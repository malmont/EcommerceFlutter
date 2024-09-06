import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/category/category.dart';
import '../../entities/product/product_response.dart';
import '../../repositories/product_repository.dart';

class GetProductUseCase
    implements UseCase<ProductResponse, FilterProductParams> {
  final ProductRepository repository;
  GetProductUseCase(this.repository);

  @override
  Future<Either<Failure, ProductResponse>> call(
      FilterProductParams params) async {
    return await repository.getProducts(params);
  }
}
class FilterProductParams {
  final String? keyword;
  final List<Category> categories;
  final double minPrice;
  final double maxPrice;
  final int? limit;  // Utilisé comme numéro de page
  final int? pageSize;  // Taille des résultats par page

  const FilterProductParams({
    this.keyword = '',
    this.categories = const [],
    this.minPrice = 0,
    this.maxPrice = 10000,
    this.limit = 1,  // La page commence à 1
    this.pageSize = 10,  // Par défaut, 10 éléments par page
  });

  // Méthode copyWith pour créer une nouvelle instance en modifiant certains champs
  FilterProductParams copyWith({
    String? keyword,
    List<Category>? categories,
    double? minPrice,
    double? maxPrice,
    int? limit,  // Pour gérer l'incrémentation de la page
    int? pageSize,  // Taille de la page si besoin
  }) =>
      FilterProductParams(
        keyword: keyword ?? this.keyword,
        categories: categories ?? this.categories,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        limit: limit ?? this.limit,  // Utiliser le limit pour gérer la page
        pageSize: pageSize ?? this.pageSize,  // Garder la taille de page
      );
}

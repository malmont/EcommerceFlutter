import 'package:equatable/equatable.dart';


class Category extends Equatable {
  final int id;
  final String name;
  final String description;
  final String image;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "image": image,
    };
  }

  @override
  List<Object?> get props => [id, name, description, image];
}

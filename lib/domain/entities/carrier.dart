import 'package:equatable/equatable.dart';

class Carrier extends Equatable {
  final String id;
  final String name;
  final String photo;
  final String description;
  final int price;
 

  const Carrier({
    required this.id,
    required this.name,
    required this.photo,
    required this.description,
    required this.price,
  });

  @override
  List<Object> get props => [id];
}
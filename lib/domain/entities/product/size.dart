import 'package:equatable/equatable.dart';

class Size extends Equatable {
  final int id;
  final String name;

  const Size({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

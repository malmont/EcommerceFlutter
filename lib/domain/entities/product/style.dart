import 'package:equatable/equatable.dart';

class Style extends Equatable {
  final int id;
  final String name;

  const Style({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}

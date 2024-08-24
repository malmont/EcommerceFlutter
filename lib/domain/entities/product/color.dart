import 'package:equatable/equatable.dart';

class Color extends Equatable {
  final int id;
  final String name;
  final String codeHexa;

  const Color({
    required this.id,
    required this.name,
    required this.codeHexa,
  });

  @override
  List<Object?> get props => [id, name, codeHexa];
}

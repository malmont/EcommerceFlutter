import 'package:flutter/material.dart';

class Shadows {
  // Constructeur privé car il n'est pas nécessaire d'instancier cette classe.
  Shadows._();

  static final BoxShadow coreShadow = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: const Offset(0, 1),
    blurRadius: 3,
  );

  static final BoxShadow castShadow = BoxShadow(
    color: Colors.black.withOpacity(0.08),
    offset: const Offset(0, 6),
    blurRadius: 12,
  );

  static final BoxShadow topNav = BoxShadow(
    color: Colors.black.withOpacity(0.16),
    offset: const Offset(0, 4),
    blurRadius: 8,
  );

  static final BoxShadow botNav = BoxShadow(
    color: Colors.black.withOpacity(0.16),
    offset: const Offset(0, -4),
    blurRadius: 8,
  );

  static final List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      offset: const Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static final List<BoxShadow> elevation2 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      offset: const Offset(0, 3),
      blurRadius: 7,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static final List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 3,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: const Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  static final List<BoxShadow> elevation4 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      offset: const Offset(0, 6),
      blurRadius: 10,
      spreadRadius: 4,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: const Offset(0, 2),
      blurRadius: 3,
    ),
  ];

  static final List<BoxShadow> elevation5 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      offset: const Offset(0, 8),
      blurRadius: 12,
      spreadRadius: 6,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: const Offset(0, 4),
      blurRadius: 4,
    ),
  ];

  static final List<BoxShadow> natural = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 3.0,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12.0,
      offset: const Offset(0, 6),
    ),
  ];
}

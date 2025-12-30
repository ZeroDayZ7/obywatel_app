import 'package:flutter/material.dart';

class Shadows {
  static const subtle = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
      color: Color.fromARGB(20, 0, 0, 0),
    ),
  ];

  static const low = [
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
      color: Color.fromARGB(40, 0, 0, 0),
    ),
  ];

  static const medium = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
      color: Color.fromARGB(60, 0, 0, 0),
    ),
  ];

  static const high = [
    BoxShadow(
      offset: Offset(0, 6),
      blurRadius: 24,
      spreadRadius: 0,
      color: Color.fromARGB(80, 0, 0, 0),
    ),
  ];
}

import 'package:flutter/material.dart';

class AppShadow {
  const AppShadow._();

  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(
      color: Color(0x12111827),
      blurRadius: 22,
      spreadRadius: -4,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x0A111827),
      blurRadius: 8,
      spreadRadius: -2,
      offset: Offset(0, 3),
    ),
  ];

  static const List<BoxShadow> soft = <BoxShadow>[
    BoxShadow(
      color: Color(0x10111827),
      blurRadius: 16,
      spreadRadius: -3,
      offset: Offset(0, 8),
    ),
  ];
}

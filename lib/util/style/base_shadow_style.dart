import 'package:flutter/material.dart';

class BaseShadowStyle {
  static BoxShadow common = BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 2));

  static BoxShadow bottomNavigation = BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 4,
      spreadRadius: 0,
      offset: const Offset(0, -2));

  static BoxShadow appBar = BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 4,
      spreadRadius: 0,
      offset: const Offset(0, 2));
}

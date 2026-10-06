import 'package:flutter/material.dart';

List<BoxShadow> mapShadows(
  List<BoxShadow> tokenShadows,
  bool isDark, {
  required Color shadowColor,
}) {
  return tokenShadows.map((s) {
    final alpha = (s.color.a * 255.0).round().clamp(0, 255);
    final color = isDark
        ? shadowColor.withAlpha((alpha * 1.5).round().clamp(0, 255))
        : s.color.withAlpha(alpha);
    return s.copyWith(color: color);
  }).toList();
}
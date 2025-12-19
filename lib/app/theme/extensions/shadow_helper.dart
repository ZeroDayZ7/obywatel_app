import 'package:flutter/material.dart';

List<BoxShadow> mapShadows(List<BoxShadow> tokenShadows, bool isDark) {
  return tokenShadows.map((s) {
    final alpha = (s.color.a * 255.0).round().clamp(0, 255);
    final color = isDark
        ? Colors.white.withAlpha(alpha)
        : s.color.withAlpha(alpha);
    return s.copyWith(color: color);
  }).toList();
}

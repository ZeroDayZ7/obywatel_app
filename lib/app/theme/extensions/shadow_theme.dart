import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/extensions/shadow_helper.dart';
import 'package:obywatel_plus/core/design/tokens/shadows.dart';

enum ShadowLevel { subtle, low, medium, high }

class ShadowTheme extends ThemeExtension<ShadowTheme> {
  final List<BoxShadow> subtle;
  final List<BoxShadow> low;
  final List<BoxShadow> medium;
  final List<BoxShadow> high;

  const ShadowTheme({
    required this.subtle,
    required this.low,
    required this.medium,
    required this.high,
  });

  // fabryka na podstawie trybu ciemnego/jasnego
  factory ShadowTheme.fromMode(bool isDark) {
    return ShadowTheme(
      subtle: mapShadows(Shadows.subtle, isDark),
      low: mapShadows(Shadows.low, isDark),
      medium: mapShadows(Shadows.medium, isDark),
      high: mapShadows(Shadows.high, isDark),
    );
  }

  // helper zwracający cień po enum
  List<BoxShadow> get(ShadowLevel level) {
    switch (level) {
      case ShadowLevel.subtle:
        return subtle;
      case ShadowLevel.low:
        return low;
      case ShadowLevel.medium:
        return medium;
      case ShadowLevel.high:
        return high;
    }
  }

  @override
  ShadowTheme copyWith({
    List<BoxShadow>? subtle,
    List<BoxShadow>? low,
    List<BoxShadow>? medium,
    List<BoxShadow>? high,
  }) {
    return ShadowTheme(
      subtle: subtle ?? this.subtle,
      low: low ?? this.low,
      medium: medium ?? this.medium,
      high: high ?? this.high,
    );
  }

  @override
  ShadowTheme lerp(ThemeExtension<ShadowTheme>? other, double t) {
    if (other is! ShadowTheme) return this;

    List<BoxShadow> lerpList(List<BoxShadow> a, List<BoxShadow> b) {
      final result = <BoxShadow>[];
      for (var i = 0; i < a.length; i++) {
        result.add(BoxShadow.lerp(a[i], b[i], t)!);
      }
      return result;
    }

    return ShadowTheme(
      subtle: lerpList(subtle, other.subtle),
      low: lerpList(low, other.low),
      medium: lerpList(medium, other.medium),
      high: lerpList(high, other.high),
    );
  }
}

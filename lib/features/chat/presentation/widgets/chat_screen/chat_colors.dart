// lib/features/chat/presentation/chat/widgets/chat_colors.dart
import 'package:flutter/material.dart';

class CyberpunkColors {
  // Tło całego chatu / scaffold
  static const Color background = Color(0xFF0A0E27);

  // Główny kolor "primary" do glow, ikon, borderów
  static const Color primary = Color(0xFF00F0FF);

  // Kolor akcentowy, np. dodawanie nowego chatu
  static const Color accent = Color(0xFFFF006B);

  // Gradienty dla avatarów, chipów, itp.
  static const List<Color> avatarGradient = [primary, accent];

  static const List<Color> chipSelectedGradient = [primary, accent];

  // Kolor dla nieaktywnego elementu / border nieaktywny
  static const Color inactiveBorder = Color(0xFF1A1F3A);

  // Kolor dla tekstów w cyberpunkowym stylu
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB537F2);
}

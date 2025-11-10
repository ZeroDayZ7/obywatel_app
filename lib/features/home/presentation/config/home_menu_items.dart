import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';

/// Główne kafelki menu na ekranie Home.
const List<Map<String, dynamic>> homeMenuItems = [
  {
    'icon': Icons.message,
    'label': 'Czaty',
    'route': AppRoutes.chats,
    'color': Color(0xFF00FF88),
  },
  {
    'icon': Icons.contacts,
    'label': 'Kontakty',
    'route': AppRoutes.contacts,
    'color': Color(0xFF00F0FF),
  },
  {
    'icon': Icons.explore,
    'label': 'Odkryj',
    'route': AppRoutes.explore,
    'color': Color(0xFFFFA500),
  },
  {
    'icon': Icons.person,
    'label': 'Ja',
    'route': AppRoutes.profile,
    'color': Color(0xFFFF00F5),
  },
  {
    'icon': Icons.folder,
    'label': 'Dokumenty',
    'route': AppRoutes.documents,
    'color': Color(0xFF5500FF),
  },
  {
    'icon': Icons.payment,
    'label': 'Płatności',
    'route': AppRoutes.payments,
    'color': Color(0xFFFFD700),
  },
  {
    'icon': Icons.notifications,
    'label': 'Powiadomienia',
    'route': AppRoutes.notifications,
    'color': Color(0xFFFF0055),
  },
  {
    'icon': Icons.store,
    'label': 'Sklep',
    'route': AppRoutes.store,
    'color': Color(0xFF00FFFF),
  },
  {
    'icon': Icons.local_hospital,
    'label': 'Zdrowie',
    'route': AppRoutes.health,
    'color': Color(0xFFFF0099),
  },
  {
    'icon': Icons.school,
    'label': 'Edukacja',
    'route': AppRoutes.education,
    'color': Color(0xFF00D4FF),
  },
  {
    'icon': Icons.games,
    'label': 'Gry',
    'route': AppRoutes.games,
    'color': Color(0xFFFF6600),
  },
  {
    'icon': Icons.video_call,
    'label': 'Wideo',
    'route': AppRoutes.videos,
    'color': Color(0xFFFF3366),
  },
  {
    'icon': Icons.favorite,
    'label': 'Ulubione',
    'route': AppRoutes.favorites,
    'color': Color(0xFFAA00FF),
  },
  {
    'icon': Icons.settings,
    'label': 'Ustawienia',
    'route': AppRoutes.settings,
    'color': Color(0xFF888899),
  },
  {
    'icon': Icons.help,
    'label': 'Pomoc',
    'route': AppRoutes.help,
    'color': Color(0xFF88FF00),
  },
  {
    'icon': Icons.security,
    'label': 'Bezpieczeństwo',
    'route': AppRoutes.security,
    'color': Color(0xFF0099FF),
  },
];

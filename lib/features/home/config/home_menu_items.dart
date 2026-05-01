import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';

/// Główne kafelki menu na ekranie Home.
final List<Map<String, dynamic>> homeMenuItems = [
  {
    'id': 'chats',
    'icon': Icons.message,
    'labelKey': LocaleKeys.homeMenu_chats,
    'route': AppRoutes.chats,
    'color': Color(0xFF00FF88),
  },
  {
    'id': 'contacts',
    'icon': Icons.contacts,
    'labelKey': LocaleKeys.homeMenu_contacts,
    'route': AppRoutes.contacts,
    'color': Color(0xFF00F0FF),
  },
  {
    'id': 'work_and_career',
    'icon': Icons.work,
    'labelKey': LocaleKeys.homeMenu_workAndCareer,
    'route': AppRoutes.workAndCareer,
    'color': Color(0xFF0077FF),
  },
  {
    'id': 'documents',
    'icon': Icons.folder,
    'labelKey': LocaleKeys.homeMenu_documents,
    'route': AppRoutes.documents,
    'color': Color(0xFF5500FF),
  },
  {
    'id': 'profile',
    'icon': Icons.person,
    'labelKey': LocaleKeys.homeMenu_profile,
    'route': AppRoutes.profile,
    'color': Color(0xFFFF00F5),
  },
  {
    'id': 'payments',
    'icon': Icons.payment,
    'labelKey': LocaleKeys.homeMenu_payments,
    'route': AppRoutes.payments,
    'color': Color(0xFFFFD700),
  },
  {
    'id': 'notifications',
    'icon': Icons.notifications,
    'labelKey': LocaleKeys.homeMenu_notifications,
    'route': AppRoutes.notifications,
    'color': Color(0xFFFF0055),
  },
  {
    'id': 'store',
    'icon': Icons.store,
    'labelKey': LocaleKeys.homeMenu_store,
    'route': AppRoutes.store,
    'color': Color(0xFF00FFFF),
  },
  {
    'id': 'health',
    'icon': Icons.local_hospital,
    'labelKey': LocaleKeys.homeMenu_health,
    'route': AppRoutes.health,
    'color': Color(0xFFFF0099),
  },
  {
    'id': 'education',
    'icon': Icons.school,
    'labelKey': LocaleKeys.homeMenu_education,
    'route': AppRoutes.education,
    'color': Color(0xFF00D4FF),
  },
  {
    'id': 'games',
    'icon': Icons.games,
    'labelKey': LocaleKeys.homeMenu_games,
    'route': AppRoutes.games,
    'color': Color(0xFFFF6600),
  },
  {
    'id': 'videos',
    'icon': Icons.video_call,
    'labelKey': LocaleKeys.homeMenu_videos,
    'route': AppRoutes.videos,
    'color': Color(0xFFFF3366),
  },
  {
    'id': 'favorites',
    'icon': Icons.favorite,
    'labelKey': LocaleKeys.homeMenu_favorites,
    'route': AppRoutes.favorites,
    'color': Color(0xFFAA00FF),
  },
  {
    'id': 'settings',
    'icon': Icons.settings,
    'labelKey': LocaleKeys.homeMenu_settings,
    'route': AppRoutes.settings,
    'color': Color(0xFF888899),
  },
  {
    'id': 'help',
    'icon': Icons.help,
    'labelKey': LocaleKeys.homeMenu_help,
    'route': AppRoutes.help,
    'color': Color(0xFF88FF00),
  },
    {
    'id': 'test',
    'icon': Icons.text_snippet,
    'labelKey': 'Test',
    'route': AppRoutes.test, 
    'color': Color(0xFF0099FF),
  },
];

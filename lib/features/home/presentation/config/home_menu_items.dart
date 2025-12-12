import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

/// Główne kafelki menu na ekranie Home.
final List<Map<String, dynamic>> homeMenuItems = [
  {
    'icon': Icons.message,
    'labelKey': LocaleKeys.homeMenu_chats,
    'route': AppRoutes.chats,
    'color': Color(0xFF00FF88),
  },
  {
    'icon': Icons.contacts,
    'labelKey': LocaleKeys.homeMenu_contacts,
    'route': AppRoutes.contacts,
    'color': Color(0xFF00F0FF),
  },
  {
    'icon': Icons.work,
    'labelKey': LocaleKeys.homeMenu_workAndCareer,
    'route': AppRoutes.workAndCareer,
    'color': Color(0xFF0077FF),
  },
  {
    'icon': Icons.folder,
    'labelKey': LocaleKeys.homeMenu_documents,
    'route': AppRoutes.documents,
    'color': Color(0xFF5500FF),
  },
  {
    'icon': Icons.person,
    'labelKey': LocaleKeys.homeMenu_profile,
    'route': AppRoutes.profile,
    'color': Color(0xFFFF00F5),
  },
  {
    'icon': Icons.payment,
    'labelKey': LocaleKeys.homeMenu_payments,
    'route': AppRoutes.payments,
    'color': Color(0xFFFFD700),
  },
  {
    'icon': Icons.notifications,
    'labelKey': LocaleKeys.homeMenu_notifications,
    'route': AppRoutes.notifications,
    'color': Color(0xFFFF0055),
  },
  {
    'icon': Icons.store,
    'labelKey': LocaleKeys.homeMenu_store,
    'route': AppRoutes.store,
    'color': Color(0xFF00FFFF),
  },
  {
    'icon': Icons.local_hospital,
    'labelKey': LocaleKeys.homeMenu_health,
    'route': AppRoutes.health,
    'color': Color(0xFFFF0099),
  },
  {
    'icon': Icons.school,
    'labelKey': LocaleKeys.homeMenu_education,
    'route': AppRoutes.education,
    'color': Color(0xFF00D4FF),
  },
  {
    'icon': Icons.games,
    'labelKey': LocaleKeys.homeMenu_games,
    'route': AppRoutes.games,
    'color': Color(0xFFFF6600),
  },
  {
    'icon': Icons.video_call,
    'labelKey': LocaleKeys.homeMenu_videos,
    'route': AppRoutes.videos,
    'color': Color(0xFFFF3366),
  },
  {
    'icon': Icons.favorite,
    'labelKey': LocaleKeys.homeMenu_favorites,
    'route': AppRoutes.favorites,
    'color': Color(0xFFAA00FF),
  },
  {
    'icon': Icons.settings,
    'labelKey': LocaleKeys.homeMenu_settings,
    'route': AppRoutes.settings,
    'color': Color(0xFF888899),
  },
  {
    'icon': Icons.help,
    'labelKey': LocaleKeys.homeMenu_help,
    'route': AppRoutes.help,
    'color': Color(0xFF88FF00),
  },
  {
    'icon': Icons.security,
    'labelKey': LocaleKeys.homeMenu_security,
    'route': AppRoutes.settingsSecurity,
    'color': Color(0xFF0099FF),
  },
];

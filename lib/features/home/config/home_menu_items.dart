import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/home/domain/model/home_menu_item.dart';

final List<HomeMenuItem> homeMenuItems = [
  HomeMenuItem(
    id: 'chats',
    icon: Icons.message,
    labelKey: LocaleKeys.homeMenu_chats,
    route: AppRoutes.chats,
    color: const Color(0xFF00FF88),
  ),
  HomeMenuItem(
    id: 'contacts',
    icon: Icons.contacts,
    labelKey: LocaleKeys.homeMenu_contacts,
    route: AppRoutes.contacts,
    color: const Color(0xFF00F0FF),
  ),
  HomeMenuItem(
    id: 'work_and_career',
    icon: Icons.work,
    labelKey: LocaleKeys.homeMenu_workAndCareer,
    route: AppRoutes.workAndCareer,
    color: const Color(0xFF0077FF),
  ),
  HomeMenuItem(
    id: 'documents',
    icon: Icons.folder,
    labelKey: LocaleKeys.homeMenu_documents,
    route: AppRoutes.documents,
    color: const Color(0xFF5500FF),
  ),
  HomeMenuItem(
    id: 'payments',
    icon: Icons.payment,
    labelKey: LocaleKeys.homeMenu_payments,
    route: AppRoutes.payments,
    color: const Color(0xFFFFD700),
    // isEnabled: false,
  ),
  HomeMenuItem(
    id: 'health',
    icon: Icons.local_hospital,
    labelKey: LocaleKeys.homeMenu_health,
    route: AppRoutes.health,
    color: const Color(0xFFFF0099),
  ),
  HomeMenuItem(
    id: 'education',
    icon: Icons.school,
    labelKey: LocaleKeys.homeMenu_education,
    route: AppRoutes.education,
    color: const Color(0xFF00D4FF),
  ),
  HomeMenuItem(
    id: 'test',
    icon: Icons.text_snippet,
     labelKey: LocaleKeys.homeMenu_test,
    route: AppRoutes.test,
    color: const Color(0xFF0099FF),
    // isHidden: true,
  ),
];

import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/home/domain/model/home_menu_item.dart';

final List<HomeMenuItem> homeMenuItems = [
  HomeMenuItem(
    id: 'work_and_career',
    icon: Icons.work,
    labelKey: LocaleKeys.homeMenu_workAndCareer,
    route: AppRoutes.workAndCareer,
    color: AppColors.serviceWork,
  ),
  HomeMenuItem(
    id: 'payments',
    icon: Icons.payment,
    labelKey: LocaleKeys.homeMenu_payments,
    route: AppRoutes.payments,
    color: AppColors.servicePayments,
    // isEnabled: false,
  ),
  HomeMenuItem(
    id: 'health',
    icon: Icons.local_hospital,
    labelKey: LocaleKeys.homeMenu_health,
    route: AppRoutes.health,
    color: AppColors.serviceHealth,
  ),
  HomeMenuItem(
    id: 'education',
    icon: Icons.school,
    labelKey: LocaleKeys.homeMenu_education,
    route: AppRoutes.education,
    color: AppColors.serviceEducation,
  ),
  HomeMenuItem(
    id: 'test',
    icon: Icons.text_snippet,
    labelKey: LocaleKeys.homeMenu_test,
    route: AppRoutes.test,
    color: AppColors.serviceTest,
    // isHidden: true,
  ),
];

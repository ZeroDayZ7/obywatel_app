import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';

class WorkAndCareerConfig {
  static List<Map<String, dynamic>> getSections(BuildContext context) {
    return [
      {
        'title': LocaleKeys.workAndCareer_title.tr(),
        'items': [
          ActionItem(
            icon: Icons.work,
            title: LocaleKeys.workAndCareer_job_offers.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.workAndCareer}/${AppRoutes.workAndCareerJobOffers}',
            ),
          ),
          ActionItem(
            icon: Icons.person,
            title: LocaleKeys.workAndCareer_my_cv.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.workAndCareer}/${AppRoutes.workAndCareerMyCV}',
            ),
          ),
          ActionItem(
            icon: Icons.send,
            title: LocaleKeys.workAndCareer_applications.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.workAndCareer}/${AppRoutes.workAndCareerApplications}',
            ),
          ),
          ActionItem(
            icon: Icons.school,
            title: LocaleKeys.workAndCareer_career_advice.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.workAndCareer}/${AppRoutes.workAndCareerCareerAdvice}',
            ),
          ),
          ActionItem(
            icon: Icons.school_outlined,
            title: LocaleKeys.workAndCareer_internships.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.workAndCareer}/${AppRoutes.workInternships}',
            ),
            // isEnabled: false,
            // isHidden: true,
          ),
          ActionItem(
            icon: Icons.handshake,
            title: LocaleKeys.workAndCareer_government_support.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.workAndCareer}/${AppRoutes.workGovernmentSupport}',
            ),
          ),
          ActionItem(
            icon: Icons.map,
            title: LocaleKeys.workAndCareer_employment_map.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.workAndCareer}/${AppRoutes.workEmploymentMap}',
            ),
            isEnabled: false,
          ),
        ],
      },
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'section_model.dart';

final List<Section> workAndCareerSections = [
  Section(
    icon: Icons.work,
    titleKey: LocaleKeys.workAndCareer_job_offers,
    route: '${AppRoutes.workAndCareer}/${AppRoutes.workAndCareerJobOffers}',
  ),
  Section(
    icon: Icons.person,
    titleKey: LocaleKeys.workAndCareer_my_cv,
    route: '${AppRoutes.workAndCareer}/${AppRoutes.workAndCareerMyCV}',
  ),
  Section(
    icon: Icons.send,
    titleKey: LocaleKeys.workAndCareer_applications,
    route: '${AppRoutes.workAndCareer}/${AppRoutes.workAndCareerApplications}',
  ),
  Section(
    icon: Icons.school,
    titleKey: LocaleKeys.workAndCareer_career_advice,
    route: '${AppRoutes.workAndCareer}/${AppRoutes.workAndCareerCareerAdvice}',
  ),
  Section(
    icon: Icons.school_outlined,
    titleKey: LocaleKeys.workAndCareer_internships,
    route: '${AppRoutes.workAndCareer}/${AppRoutes.workInternships}',
  ),
  Section(
    icon: Icons.handshake,
    titleKey: LocaleKeys.workAndCareer_government_support,
    route: '${AppRoutes.workAndCareer}/${AppRoutes.workGovernmentSupport}',
  ),
  Section(
    icon: Icons.map,
    titleKey: LocaleKeys.workAndCareer_employment_map,
    route: '${AppRoutes.workAndCareer}/${AppRoutes.workEmploymentMap}',
  ),
];

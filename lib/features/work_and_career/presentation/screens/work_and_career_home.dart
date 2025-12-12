import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/features/work_and_career/model/sections_data.dart';

class WorkAndCareerHome extends StatelessWidget {
  const WorkAndCareerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.workAndCareer_title.tr()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: workAndCareerSections.length,
          itemBuilder: (context, index) {
            final section = workAndCareerSections[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(section.icon),
                title: Text(section.titleKey.tr()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.push(section.route);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

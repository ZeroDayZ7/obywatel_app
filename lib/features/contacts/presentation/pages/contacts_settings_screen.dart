import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/widgets/ui/app_switch.dart';
import 'package:obywatel_plus/core/design/widgets/ui/section_header.dart';
import 'package:obywatel_plus/core/design/widgets/ui/settings_tile.dart';

class ContactsSettingsScreen extends StatelessWidget {
  const ContactsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(title: 'Synchronizacja'),
          AppSwitch(
            title: 'Synchronizuj z telefonem',
            value: true,
            onChanged: (v) {},
          ),
          AppSettingsTile(
            icon: Icons.import_export,
            title: 'Importuj z karty SIM',
            onTap: () {},
          ),
          AppSettingsTile(
            icon: Icons.cloud_download_outlined,
            title: 'Pobierz kontakty z chmury',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          const AppSectionHeader(title: 'Wyświetlanie'),
          AppSettingsTile(
            icon: Icons.sort_by_alpha,
            title: 'Sortuj według nazwiska',
            onTap: () {},
            trailing: const Text('A-Z', style: TextStyle(color: Colors.grey)),
          ),
          AppSwitch(
            title: 'Pokazuj tylko numery',
            value: false,
            onChanged: (v) {},
          ),

          const SizedBox(height: 24),

          const AppSectionHeader(title: 'Zarządzanie bazą'),
          AppSettingsTile(
            icon: Icons.cleaning_services_outlined,
            title: 'Połącz duplikaty',
            onTap: () {},
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '3 znalezione',
                style: TextStyle(color: Colors.orange, fontSize: 10),
              ),
            ),
          ),
          AppSettingsTile(
            icon: Icons.delete_sweep_outlined,
            title: 'Usuń nieaktywne kontakty',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          const AppSectionHeader(title: 'Prywatność'),
          AppSwitch(
            title: 'Udostępniaj status online',
            value: true,
            onChanged: (v) {},
          ),
          AppSettingsTile(
            icon: Icons.block,
            title: 'Zablokowane kontakty',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';

class ContactsSettingsConfig {
  static List<Map<String, dynamic>> getSections() {
    return [
      {
        'title': 'Synchronizacja',
        'items': [
          ActionItem(
            icon: Icons.import_export,
            title: 'Importuj z karty SIM',
            type: ActionType.navigation,
            onTap: () {},
          ),
          ActionItem(
            icon: Icons.cloud_download_outlined,
            title: 'Pobierz kontakty z chmury',
            type: ActionType.navigation,
            onTap: () {},
          ),
          ActionItem(
            icon: Icons.sync,
            title: 'Synchronizuj z telefonem',
            type: ActionType.toggle,
            initialValue: true,
            onToggle: (v) {},
          ),
        ],
      },
      {
        'title': 'Wyświetlanie',
        'items': [
          ActionItem(
            icon: Icons.sort_by_alpha,
            title: 'Sortuj według nazwiska',
            type: ActionType.navigation,
            onTap: () {},
          ),
          ActionItem(
            icon: Icons.format_list_bulleted,
            title: 'Pokazuj tylko numery',
            type: ActionType.toggle,
            initialValue: false,
            onToggle: (v) {},
          ),
        ],
      },
      {
        'title': 'Zarządzanie bazą',
        'items': [
          ActionItem(
            icon: Icons.cleaning_services_outlined,
            title: 'Połącz duplikaty',
            subtitle: '3 znalezione',
            type: ActionType.navigation,
            onTap: () {},
          ),
          ActionItem(
            icon: Icons.delete_sweep_outlined,
            title: 'Usuń nieaktywne kontakty',
            type: ActionType.navigation,
            onTap: () {},
          ),
        ],
      },
      {
        'title': 'Prywatność',
        'items': [
          ActionItem(
            icon: Icons.sync,
            title: 'Udostępniaj status online',
            type: ActionType.toggle,
            initialValue: true,
            onToggle: (v) {},
          ),
          ActionItem(
            icon: Icons.block,
            title: 'Zablokowane kontakty',
            type: ActionType.navigation,
            onTap: () {},
          ),
        ],
      },
    ];
  }
}

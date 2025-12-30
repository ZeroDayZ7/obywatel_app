import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/margins/screen_margins.dart';

class ActiveSessionsScreen extends StatelessWidget {
  const ActiveSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_security_active_sessions.tr()),
        centerTitle: true,
      ),
      body: ListView(
        padding: ScreenMargins.all,
        children: [
          _SessionTile(
            deviceName: "To urządzenie (iPhone 14)",
            lastActivity: "Teraz",
            isCurrent: true,
          ),
          const SizedBox(height: 12),
          _SessionTile(
            deviceName: "MacBook Pro 16",
            lastActivity: "2 godziny temu",
            location: "Warszawa, PL",
          ),
          const SizedBox(height: 12),
          _SessionTile(
            deviceName: "Chrome (Windows)",
            lastActivity: "Wczoraj, 18:30",
            location: "Kraków, PL",
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final String deviceName;
  final String lastActivity;
  final String? location;
  final bool isCurrent;

  const _SessionTile({
    required this.deviceName,
    required this.lastActivity,
    this.location,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(
          isCurrent ? Icons.phonelink_setup : Icons.devices,
          color: isCurrent ? Colors.green : Colors.blueGrey,
        ),
        title: Text(
          deviceName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${location ?? 'Nieznana lokalizacja'}\nOstatnio: $lastActivity",
          style: const TextStyle(fontSize: 12),
        ),
        isThreeLine: true,
        trailing: !isCurrent
            ? IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                onPressed: () {
                  // Tutaj logika wyrejestrowania urządzenia
                },
              )
            : const Badge(label: Text("Aktualna")),
      ),
    );
  }
}

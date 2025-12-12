import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text("App notifications"),
            value: true,
            onChanged: (v) {},
          ),
          SwitchListTile(
            title: const Text("Sound"),
            value: true,
            onChanged: (v) {},
          ),
          SwitchListTile(
            title: const Text("Vibration"),
            value: false,
            onChanged: (v) {},
          ),
        ],
      ),
    );
  }
}

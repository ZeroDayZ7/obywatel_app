import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/widgets/ui/app_switch.dart';

class ChatSettingsScreen extends StatelessWidget {
  const ChatSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Security'),
          AppSwitch(
            title: 'End-to-End Encryption',
            value: true,
            onChanged: (v) {},
          ),
          AppSwitch(title: 'Stealth Mode', value: false, onChanged: (v) {}),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Appearance'),
          _buildOptionTile(context, Icons.palette, 'Chat Wallpaper'),
          _buildOptionTile(context, Icons.font_download, 'Font Size'),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Notifications'),
          AppSwitch(
            title: 'Push Notifications',
            value: true,
            onChanged: (v) {},
          ),
          AppSwitch(title: 'Sound Effects', value: true, onChanged: (v) {}),
          const SizedBox(height: 32),
          Center(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
              ),
              child: const Text('Wipe All Data'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {},
    );
  }
}

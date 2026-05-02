import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/widgets/ui/app_switch.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/design/widgets/ui/section_header.dart';
import 'package:obywatel_plus/core/design/widgets/ui/settings_tile.dart';

class ChatSettingsScreen extends StatelessWidget {
  const ChatSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(title: 'Security'),
          AppSwitch(
            title: 'End-to-End Encryption',
            value: true,
            onChanged: (v) {},
          ),
          AppSwitch(title: 'Stealth Mode', value: false, onChanged: (v) {}),

          const SizedBox(height: 24),

          const AppSectionHeader(title: 'Appearance'),
          AppSettingsTile(
            icon: Icons.palette,
            title: 'Chat Wallpaper',
            onTap: () {},
          ),
          AppSettingsTile(
            icon: Icons.font_download,
            title: 'Font Size',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          const AppSectionHeader(title: 'Notifications'),
          AppSwitch(
            title: 'Push Notifications',
            value: true,
            onChanged: (v) {},
          ),

          const SizedBox(height: 32),

          Center(
            child: AppButton(
              labelKey: 'Wipe All Data',
              onPressed: () {},
              variant: AppButtonVariant.secondary, 
            ),
          ),
        ],
      ),
    );
  }
}

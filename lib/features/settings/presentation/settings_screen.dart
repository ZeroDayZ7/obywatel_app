import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'theme_selector_sheet.dart';

import 'package:obywatel_plus/features/settings/presentation/security/fingerprint_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/security/set_pin_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/security/pattern_lock_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Sekcja General Settings – dodana karta Theme
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'General Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            _SettingsCard(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage app notifications',
              onTap: () {},
            ),
            _SettingsCard(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'Choose your preferred language',
              onTap: () {},
            ),
            _SettingsCard(
              icon: Icons.palette,
              title: 'Theme',
              subtitle: 'Select light, dark or system theme',
              onTap: () => _showThemeSelectorSheet(context, ref),
            ),
            const SizedBox(height: 24),

            // Sekcja Security – karta do sub-ekranu
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Security & Access',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            _SettingsCard(
              icon: Icons.security,
              title: 'Security',
              subtitle: 'Manage PIN, pattern and biometrics',
              onTap: () =>
                  context.push('${AppRoutes.settings}/${AppRoutes.security}'),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelectorSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<ThemeMode>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ThemeSelectorSheet(),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SettingsCard(
              icon: Icons.pin,
              title: 'Set PIN',
              subtitle: 'Choose a PIN to unlock the app',
              onTap: () => _showModal(context, const SetPinModal()),
            ),
            _SettingsCard(
              icon: Icons.gesture,
              title: 'Pattern Lock',
              subtitle: 'Draw a pattern to unlock the app',
              onTap: () => _showModal(context, const PatternLockScreen()),
            ),
            _SettingsCard(
              icon: Icons.fingerprint,
              title: 'Fingerprint',
              subtitle: 'Use fingerprint to unlock the app',
              onTap: () => _showModal(context, const FingerprintScreen()),
            ),
          ],
        ),
      ),
    );
  }

  void _showModal(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      ),
    );
  }
}

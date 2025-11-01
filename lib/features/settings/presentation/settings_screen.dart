import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
// import 'package:obywatel_plus/app/theme/theme_notifier.dart'; // Import dla themeProvider
import 'theme_selector_sheet.dart'; // Import Twojego ThemeSelectorSheet

class SettingsScreen extends ConsumerWidget {
  // Zmiana na ConsumerWidget dla Riverpod
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User info – bez zmian
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/avatar_placeholder.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Citizen ID: 123456789',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

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
              onTap: () {}, // W przyszłości: context.push do sub-ekranu
            ),
            _SettingsCard(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'Choose your preferred language',
              onTap: () {}, // W przyszłości: context.push do sub-ekranu
            ),
            _SettingsCard(
              icon: Icons.palette, // Ikona dla theme
              title: 'Theme',
              subtitle: 'Select light, dark or system theme',
              onTap: () => _showThemeSelectorSheet(context, ref),
            ),
            const SizedBox(height: 24),

            // Sekcja Security – teraz jedna karta do sub-ekranu
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

  // Funkcja do otwierania bottom sheet z theme
  void _showThemeSelectorSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<ThemeMode>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ThemeSelectorSheet(), // Twój sheet z Riverpod
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

// Przykładowy sub-ekran Security – dodaj do AppRoutes: security = 'security'
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
            // Tu wracają karty security
            _SettingsCard(
              icon: Icons.pin,
              title: 'Set PIN',
              subtitle: 'Choose a PIN to unlock the app',
              onTap: () =>
                  context.push('${AppRoutes.settings}/${AppRoutes.setPin}'),
            ),
            _SettingsCard(
              icon: Icons.gesture,
              title: 'Pattern Lock',
              subtitle: 'Draw a pattern to unlock the app',
              onTap: () => context.push(
                '${AppRoutes.settings}/${AppRoutes.patternLock}',
              ),
            ),
            _SettingsCard(
              icon: Icons.fingerprint,
              title: 'Fingerprint',
              subtitle: 'Use fingerprint to unlock the app',
              onTap: () => context.push(
                '${AppRoutes.settings}/${AppRoutes.fingerprint}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

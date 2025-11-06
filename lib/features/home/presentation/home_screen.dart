import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/theme/app_text_styles.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/main_drawer.dart';
import './widgets/home_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final _homeItems = [
    {'icon': Icons.person, 'label': 'Profile', 'route': AppRoutes.profile},
    {'icon': Icons.folder, 'label': 'Documents', 'route': AppRoutes.documents},
    {
      'icon': Icons.notifications,
      'label': 'Notifications',
      'route': AppRoutes.notifications,
    },
    {'icon': Icons.settings, 'label': 'Settings', 'route': AppRoutes.settings},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(apiConstants.appName),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'version':
                  showAboutDialog(
                    context: context,
                    applicationName: apiConstants.appName,
                    applicationVersion: '1.0.0',
                    children: const [Text('Material 3 Playground Demo')],
                  );
                  break;
                case 'contact':
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Contact Us'),
                      content: const Text(
                        'Email: support@example.com\nPhone: +48 123 456 789',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                  break;
                case 'theme':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Theme options coming soon')),
                  );
                  break;
                case 'switch':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Switch / Toggle demo')),
                  );
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'version',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('App Version'),
                ),
              ),
              PopupMenuItem(
                value: 'contact',
                child: ListTile(
                  leading: Icon(Icons.contact_mail),
                  title: Text('Contact Us'),
                ),
              ),
              PopupMenuItem(
                value: 'theme',
                child: ListTile(
                  leading: Icon(Icons.palette),
                  title: Text('Theme Options'),
                ),
              ),
              PopupMenuItem(
                value: 'switch',
                child: ListTile(
                  leading: Icon(Icons.toggle_on),
                  title: Text('Switch / Toggle Demo'),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Welcome back!', style: AppTextStyles.headline),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: _homeItems
                  .map(
                    (item) => HomeCard(
                      icon: item['icon'] as IconData,
                      label: item['label'] as String,
                      onTap: () => context.push(item['route'] as String),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 32),
            const Text(
              'Material 3 Widgets Demo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Buttons
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
                const SizedBox(width: 8),
                TextButton(onPressed: () {}, child: const Text('Text')),
              ],
            ),
            const SizedBox(height: 16),
            // Chips
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('Chip 1')),
                Chip(label: Text('Chip 2')),
                Chip(label: Text('Chip 3')),
              ],
            ),
            const SizedBox(height: 16),
            // Switches and Sliders
            Row(
              children: [
                const Text('Switch:'),
                const SizedBox(width: 8),
                Switch(value: true, onChanged: (_) {}),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Slider:'),
                const SizedBox(width: 8),
                Expanded(child: Slider(value: 0.5, onChanged: (_) {})),
              ],
            ),
            const SizedBox(height: 16),
            // ListTiles
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('ListTile Example 1'),
              trailing: Icon(Icons.arrow_forward),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('ListTile Example 2'),
              trailing: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}

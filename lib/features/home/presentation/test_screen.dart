import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  static final _menuItems = [
    {'icon': Icons.message, 'label': 'Czaty', 'color': Colors.green},
    {'icon': Icons.contacts, 'label': 'Kontakty', 'color': Colors.blue},
    {'icon': Icons.explore, 'label': 'Odkryj', 'color': Colors.orange},
    {'icon': Icons.person, 'label': 'Ja', 'color': Colors.purple},
    {'icon': Icons.folder, 'label': 'Dokumenty', 'color': Colors.indigo},
    {'icon': Icons.payment, 'label': 'Płatności', 'color': Colors.amber},
    {
      'icon': Icons.notifications,
      'label': 'Powiadomienia',
      'color': Colors.red,
    },
    {'icon': Icons.store, 'label': 'Sklep', 'color': Colors.teal},
    {'icon': Icons.local_hospital, 'label': 'Zdrowie', 'color': Colors.pink},
    {'icon': Icons.school, 'label': 'Edukacja', 'color': Colors.cyan},
    {'icon': Icons.games, 'label': 'Gry', 'color': Colors.brown},
    {'icon': Icons.video_call, 'label': 'Wideo', 'color': Colors.deepOrange},
    {'icon': Icons.favorite, 'label': 'Ulubione', 'color': Colors.deepPurple},
    {'icon': Icons.settings, 'label': 'Ustawienia', 'color': Colors.grey},
    {'icon': Icons.help, 'label': 'Pomoc', 'color': Colors.lightGreen},
    {
      'icon': Icons.security,
      'label': 'Bezpieczeństwo',
      'color': Colors.blueGrey,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'WeChat Test',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: () {}, // Placeholder dla search
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {}, // Placeholder dla menu
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sekcja menu grid (rozbudowane jak w WeChat Discover)
            const Text(
              'Usługi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 5 : 4;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _menuItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    final color = item['color'] as Color;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            size: 24,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            item['label'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

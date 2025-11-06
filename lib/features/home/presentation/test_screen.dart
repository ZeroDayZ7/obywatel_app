import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  static final _recentChats = [
    {
      'name': 'Jan Kowalski',
      'message': 'Cześć! Jak leci?',
      'time': '10:30',
      'unread': 2,
    },
    {
      'name': 'Anna Nowak',
      'message': 'Spotkanie o 14:00',
      'time': '09:45',
      'unread': 0,
    },
    {
      'name': 'Piotr Wiśniewski',
      'message': 'Dzięki za plik!',
      'time': '08:20',
      'unread': 1,
    },
    {
      'name': 'Kasia Zając',
      'message': 'Zdjęcia z wakacji',
      'time': '07:15',
      'unread': 0,
    },
    {
      'name': 'Michał Lewandowski',
      'message': 'Przypomnienie o...',
      'time': '06:50',
      'unread': 3,
    },
  ];

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
            // Sekcja wyszukiwania
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Wyszukaj czaty, kontakty...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sekcja ostatnich czatów (jak w WeChat)
            const Text(
              'Ostatnie czaty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._recentChats.map(
              (chat) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          (chat['name'] as String)
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if ((chat['unread'] as int) > 0)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${chat['unread']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    chat['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(chat['message'] as String),
                  trailing: Text(
                    chat['time'] as String,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

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
            const SizedBox(height: 24),

            // Placeholder dla Moments (jak w WeChat)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.public, color: Colors.white),
                    ),
                    title: const Text(
                      'Moments',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Tutaj pojawią się posty z Moments...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Placeholder dla dolnego paska nawigacyjnego (tylko wygląd)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomNavItem(
                    Icons.message,
                    'Czaty',
                    true,
                    Colors.green,
                  ),
                  _buildBottomNavItem(
                    Icons.contacts,
                    'Kontakty',
                    false,
                    Colors.blue,
                  ),
                  _buildBottomNavItem(
                    Icons.explore,
                    'Odkryj',
                    false,
                    Colors.orange,
                  ),
                  _buildBottomNavItem(Icons.person, 'Ja', false, Colors.purple),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    IconData icon,
    String label,
    bool isActive,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? color : Colors.grey, size: 24),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? color : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

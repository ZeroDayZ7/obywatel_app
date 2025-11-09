import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final _menuItems = [
    {'icon': Icons.message, 'label': 'Czaty', 'color': Color(0xFF00FF88)},
    {'icon': Icons.contacts, 'label': 'Kontakty', 'color': Color(0xFF00F0FF)},
    {'icon': Icons.explore, 'label': 'Odkryj', 'color': Color(0xFFFFA500)},
    {'icon': Icons.person, 'label': 'Ja', 'color': Color(0xFFFF00F5)},
    {'icon': Icons.folder, 'label': 'Dokumenty', 'color': Color(0xFF5500FF)},
    {'icon': Icons.payment, 'label': 'Płatności', 'color': Color(0xFFFFD700)},
    {
      'icon': Icons.notifications,
      'label': 'Powiadomienia',
      'color': Color(0xFFFF0055),
    },
    {'icon': Icons.store, 'label': 'Sklep', 'color': Color(0xFF00FFFF)},
    {
      'icon': Icons.local_hospital,
      'label': 'Zdrowie',
      'color': Color(0xFFFF0099),
    },
    {'icon': Icons.school, 'label': 'Edukacja', 'color': Color(0xFF00D4FF)},
    {'icon': Icons.games, 'label': 'Gry', 'color': Color(0xFFFF6600)},
    {'icon': Icons.video_call, 'label': 'Wideo', 'color': Color(0xFFFF3366)},
    {'icon': Icons.favorite, 'label': 'Ulubione', 'color': Color(0xFFAA00FF)},
    {'icon': Icons.settings, 'label': 'Ustawienia', 'color': Color(0xFF888899)},
    {'icon': Icons.help, 'label': 'Pomoc', 'color': Color(0xFF88FF00)},
    {
      'icon': Icons.security,
      'label': 'Bezpieczeństwo',
      'color': Color(0xFF0099FF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0F),
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Color(0xFF00F0FF), Color(0xFFFF00F5)],
          ).createShader(bounds),
          child: Text(
            apiConstants.appName,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF0A0A0F),
        iconTheme: IconThemeData(color: Color(0xFF00F0FF)),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF1F1F2E), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.search, color: Color(0xFF00F0FF), size: 22),
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF1F1F2E), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.more_vert, color: Color(0xFF00F0FF), size: 22),
              onPressed: () {},
            ),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0A0F), Color(0xFF1A0F2E), Color(0xFF0F1A2E)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF00F0FF), width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF00FF88),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF00FF88),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'SYSTEM AKTYWNY',
                      style: TextStyle(
                        color: Color(0xFF00F0FF),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Główny tytuł sekcji
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF00F0FF), Color(0xFFFF00F5)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'USŁUGI',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Grid menu
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
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final color = item['color'] as Color;
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF1F1F2E),
                              width: 1,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E)],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: color.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      color.withValues(alpha: 0.2),
                                      color.withValues(alpha: 0.2),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  size: 26,
                                  color: color,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Text(
                                  item['label'] as String,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // Footer info
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF1F1F2E), width: 1),
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E)],
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield, color: Color(0xFF00FF88), size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Połączenie zabezpieczone • Szyfrowanie E2E',
                        style: TextStyle(
                          color: Color(0xFF6B6B7A),
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

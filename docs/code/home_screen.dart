import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/main_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final _homeItems = [
    {
      'icon': Icons.person,
      'label': 'Profile',
      'route': AppRoutes.profile,
      'subtitle': 'Manage identity',
      'color': Color(0xFF00F0FF),
    },
    {
      'icon': Icons.folder,
      'label': 'Documents',
      'route': AppRoutes.documents,
      'subtitle': 'Secure storage',
      'color': Color(0xFFFF00F5),
    },
    {
      'icon': Icons.notifications,
      'label': 'Notifications',
      'route': AppRoutes.notifications,
      'subtitle': 'System alerts',
      'color': Color(0xFFFFA500),
    },
    {
      'icon': Icons.settings,
      'label': 'Settings',
      'route': AppRoutes.settings,
      'subtitle': 'Configuration',
      'color': Color(0xFF00FF88),
    },
    {
      'icon': Icons.security,
      'label': 'Security',
      'route': '/security',
      'subtitle': 'Access control',
      'color': Color(0xFFFF0055),
    },
    {
      'icon': Icons.analytics,
      'label': 'Analytics',
      'route': '/analytics',
      'subtitle': 'Data insights',
      'color': Color(0xFF5500FF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0F),
      appBar: MainAppBar(title: apiConstants.appName),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0A0F), Color(0xFF1A0F2E), Color(0xFF0F1A2E)],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF00F0FF), width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'SYSTEM ONLINE',
                        style: TextStyle(
                          color: Color(0xFF00F0FF),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xFF00F0FF), Color(0xFFFF00F5)],
                      ).createShader(bounds),
                      child: Text(
                        'NEURAL INTERFACE',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Access all systems and modules',
                      style: TextStyle(
                        color: Color(0xFF8B8B9A),
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF1F1F2E), width: 1),
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E)],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFF00F0FF),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                    0xFF00F0FF,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person,
                              color: Color(0xFF00F0FF),
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID: USER-2035-ALPHA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Clearance Level: Maximum',
                                  style: TextStyle(
                                    color: Color(0xFF00FF88),
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF00FF88),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF00FF88),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate((context, i) {
                  final item = _homeItems[i];
                  return GestureDetector(
                    onTap: () => context.push(item['route'] as String),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFF1F1F2E), width: 1),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E)],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(40),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    (item['color'] as Color).withValues(
                                      alpha: 0.15,
                                    ),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: (item['color'] as Color)
                                          .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        (item['color'] as Color).withValues(
                                          alpha: 0.1,
                                        ),
                                        (item['color'] as Color).withValues(
                                          alpha: 0.05,
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    color: item['color'] as Color,
                                    size: 28,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  item['label'] as String,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item['subtitle'] as String,
                                  style: TextStyle(
                                    color: Color(0xFF6B6B7A),
                                    fontSize: 12,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: _homeItems.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

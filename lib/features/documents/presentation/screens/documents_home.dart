import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dokumenty'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          _buildCategoryHeader('Tożsamość i Obywatelstwo'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              delegate: SliverChildListDelegate([
                _DocumentCard(
                  title: 'Dowód osobisty',
                  icon: Icons.badge,
                  color: Colors.blue,
                  onTap: () => context.push(AppRoutes.idCard),
                  isVerfied: true,
                ),
                _DocumentCard(
                  title: 'Paszport',
                  icon: Icons.public,
                  color: Colors.red.shade900,
                  onTap: () {},
                ),
              ]),
            ),
          ),
          _buildCategoryHeader('Uprawnienia i Praca'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              delegate: SliverChildListDelegate([
                _DocumentCard(
                  title: 'Prawo jazdy',
                  icon: Icons.directions_car,
                  color: Colors.green,
                  onTap: () {},
                  status: 'Kat. B, A',
                ),
                _DocumentCard(
                  title: 'Karta Dużej Rodziny',
                  icon: Icons.family_restroom,
                  color: Colors.orange,
                  onTap: () {},
                ),
                _DocumentCard(
                  title: 'Legitymacja emeryta',
                  icon: Icons.elderly,
                  color: Colors.teal,
                  onTap: () {},
                ),
                _DocumentCard(
                  title: 'Pozwolenie na broń',
                  icon: Icons.security,
                  color: Colors.blueGrey,
                  onTap: () {},
                ),
              ]),
            ),
          ),
          _buildCategoryHeader('Edukacja'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _WideDocumentCard(
                  title: 'Legitymacja studencka',
                  subtitle: 'Politechnika Warszawska',
                  icon: Icons.school,
                  color: Colors.indigo,
                  expiry: 'Ważna do 31.10.2026',
                ),
              ]),
            ),
          ),
          _buildCategoryHeader('Transport i Podróże'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _TicketTile(
                  title: 'Bilet okresowy - ZTM Warszawa',
                  subtitle: '90-dniowy • Strefa 1+2',
                  icon: Icons.directions_bus,
                  color: Colors.red,
                ),
                _TicketTile(
                  title: 'Karta lojalnościowa PKP',
                  subtitle: 'Intercity Premium',
                  icon: Icons.train,
                  color: Colors.orange.shade800,
                ),
                _TicketTile(
                  title: 'Bilet lotniczy: WAW -> JFK',
                  subtitle: '24 Maj 2026 • LOT Polish Airlines',
                  icon: Icons.flight_takeoff,
                  color: Colors.blue.shade800,
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isVerfied;
  final String? status;

  const _DocumentCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isVerfied = false,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha:0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha:0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                if (isVerfied)
                  const Icon(Icons.verified, color: Colors.blue, size: 20),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                if (status != null)
                  Text(status!, style: TextStyle(fontSize: 11, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WideDocumentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String expiry;
  final IconData icon;
  final Color color;

  const _WideDocumentCard({
    required this.title,
    required this.subtitle,
    required this.expiry,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withValues(alpha:0.7)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 48),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  expiry,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
        ],
      ),
    );
  }
}

class _TicketTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _TicketTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha:0.03) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.qr_code, size: 24),
        onTap: () {},
      ),
    );
  }
}

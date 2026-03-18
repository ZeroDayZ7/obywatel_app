// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// --- NOWY, NIEZALEŻNY MODEL DLA TEGO EKRANU ---
class UIContact {
  final String id;
  final String name;
  final String phone;
  final bool isOnline;
  final bool isVerified;
  final String category;
  final String avatarInitials;
  final Color glowColor;

  UIContact({
    required this.id,
    required this.name,
    required this.phone,
    this.isOnline = false,
    this.isVerified = false,
    required this.category,
    required this.avatarInitials,
    required this.glowColor,
  });
}

class ContactsScreen extends StatefulWidget {
  ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  static const Color _bgDark = Color(0xFF0A0E27);
  static const Color _primaryNeon = Color(0xFF00F0FF);
  static const Color _accentNeon = Color(0xFFFF00F5);
  static const Color _successNeon = Color(0xFF00FF88);
  static const Color _surfaceColor = Color(0xFF1A1A2E);

  // Upewnij się, że ta lista ma jawnie określony typ <UIContact>
  final List<UIContact> _data = [
    UIContact(
      id: '1',
      name: 'Anna Kowalska',
      phone: '+48 500 111 222',
      isOnline: true,
      isVerified: true,
      category: 'Ulubione',
      avatarInitials: 'AK',
      glowColor: _primaryNeon,
    ),
    UIContact(
      id: '2',
      name: 'Jan Nowak',
      phone: '+48 600 333 444',
      isOnline: false,
      isVerified: true,
      category: 'Rodzina',
      avatarInitials: 'JN',
      glowColor: _accentNeon,
    ),
    UIContact(
      id: '3',
      name: 'Marta Wiśniewska',
      phone: '+48 700 555 666',
      isOnline: true,
      isVerified: false,
      category: 'Praca',
      avatarInitials: 'MW',
      glowColor: Colors.orangeAccent,
    ),
    UIContact(
      id: '4',
      name: 'Piotr Krawczyk',
      phone: '+48 800 777 888',
      isOnline: false,
      isVerified: true,
      category: 'Praca',
      avatarInitials: 'PK',
      glowColor: _primaryNeon,
    ),
    UIContact(
      id: '5',
      name: 'Kpt. Tomasz Lis',
      phone: 'Szyfrowane: 998',
      isOnline: true,
      isVerified: true,
      category: 'Służby',
      avatarInitials: 'TL',
      glowColor: Colors.redAccent,
    ),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'Wszyscy';
  final List<String> _categories = [
    'Wszyscy',
    'Ulubione',
    'Rodzina',
    'Praca',
    'Służby',
  ];
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // JAWNE rzutowanie wyniku filtrowania na List<UIContact>
    final List<UIContact> filtered = _data.where((c) {
      final matchesSearch = c.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesCategory =
          _selectedCategory == 'Wszyscy' || c.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: _bgDark,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildOnlineSection(),
          _buildCategoryFilters(),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildContactCard(filtered[index]),
              childCount: filtered.length,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: _buildFAB(),
      extendBody: true,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- KOMPONENTY UI ---

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 140.0,
      floating: true,
      pinned: true,
      backgroundColor: _bgDark.withValues(alpha: 0.9),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 16, bottom: 16),
        title: Text(
          'Książka Kontaktów',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 18,
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Szukaj obywatela...',
                hintStyle: TextStyle(color: Colors.white38),
                prefixIcon: Icon(CupertinoIcons.search, color: _primaryNeon),
                border: InputBorder.none,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineSection() {
    final onlineOnes = _data.where((c) => c.isOnline).toList();
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'DOSTĘPNI W SIECI',
              style: TextStyle(
                color: _primaryNeon,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: onlineOnes.length,
              itemBuilder: (context, index) =>
                  _buildOnlineAvatar(onlineOnes[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineAvatar(UIContact contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _successNeon, width: 2),
              boxShadow: [
                BoxShadow(
                  color: _successNeon.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(
                contact.avatarInitials,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            contact.name.split(' ')[0],
            style: TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 45,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final cat = _categories[index];
            final sel = _selectedCategory == cat;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: sel
                      ? _primaryNeon.withValues(alpha: 0.1)
                      : _surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: sel ? _primaryNeon : Colors.white10,
                  ),
                ),
                child: Center(
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: sel ? _primaryNeon : Colors.white60,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContactCard(UIContact contact) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: contact.glowColor.withValues(alpha: 0.2),
                child: Text(
                  contact.avatarInitials,
                  style: TextStyle(color: contact.glowColor),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          contact.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (contact.isVerified)
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.verified,
                              color: _primaryNeon,
                              size: 14,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      contact.phone,
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                color: Colors.white24,
                size: 16,
              ),
            ],
          ),
          Divider(height: 24, color: Colors.white10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _action(CupertinoIcons.phone, _successNeon),
              _action(CupertinoIcons.lock_shield, _primaryNeon),
              _action(CupertinoIcons.paperplane, _accentNeon),
              _action(CupertinoIcons.delete, Colors.white24),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(IconData icon, Color col) => Icon(icon, color: col, size: 20);

  Widget _buildFAB() {
    return FloatingActionButton(
      backgroundColor: _bgDark,
      shape: CircleBorder(side: BorderSide(color: _primaryNeon, width: 2)),
      onPressed: () {},
      child: Icon(Icons.person_add_alt_1, color: _primaryNeon),
    );
  }

  Widget _buildBottomNav() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: BottomNavigationBar(
          backgroundColor: _bgDark.withValues(alpha: 0.5),
          selectedItemColor: _primaryNeon,
          unselectedItemColor: Colors.white30,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_2),
              label: 'Kontakty',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble),
              label: 'Czaty',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Opcje',
            ),
          ],
        ),
      ),
    );
  }
}

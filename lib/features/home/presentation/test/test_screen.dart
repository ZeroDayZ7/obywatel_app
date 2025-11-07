import 'package:flutter/material.dart';

void main() {
  runApp(const WeChatApp());
}

class WeChatApp extends StatelessWidget {
  const WeChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF07C160),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),
      home: const WeChatHomeScreen(),
    );
  }
}

class WeChatHomeScreen extends StatefulWidget {
  const WeChatHomeScreen({super.key});

  @override
  State<WeChatHomeScreen> createState() => _WeChatHomeScreenState();
}

class _WeChatHomeScreenState extends State<WeChatHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ChatsPage(),
    const ContactsPage(),
    const DiscoverPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.contacts_outlined),
            selectedIcon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}

// CHATS PAGE
class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WeChat',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildChatItem(
            context,
            name: 'John Smith',
            message: 'Hey! How are you doing today?',
            time: '10:23',
            avatar: Icons.person,
            avatarColor: Colors.blue,
            unreadCount: 3,
          ),
          _buildChatItem(
            context,
            name: 'Work Team',
            message: 'Alice: The meeting starts at 3 PM',
            time: '09:45',
            avatar: Icons.group,
            avatarColor: Colors.orange,
            unreadCount: 12,
          ),
          _buildChatItem(
            context,
            name: 'Sarah Johnson',
            message: 'Thanks for your help! 😊',
            time: 'Yesterday',
            avatar: Icons.person,
            avatarColor: Colors.purple,
            unreadCount: 0,
          ),
          _buildChatItem(
            context,
            name: 'Mom',
            message: 'Don\'t forget to call me',
            time: 'Yesterday',
            avatar: Icons.favorite,
            avatarColor: Colors.pink,
            unreadCount: 1,
          ),
          _buildChatItem(
            context,
            name: 'Gaming Squad',
            message: 'Mike: Anyone up for a game tonight?',
            time: 'Wednesday',
            avatar: Icons.videogame_asset,
            avatarColor: Colors.green,
            unreadCount: 0,
          ),
          _buildChatItem(
            context,
            name: 'David Chen',
            message: 'See you tomorrow!',
            time: 'Tuesday',
            avatar: Icons.person,
            avatarColor: Colors.teal,
            unreadCount: 0,
          ),
          _buildChatItem(
            context,
            name: 'Emma Wilson',
            message: 'Photo',
            time: 'Monday',
            avatar: Icons.person,
            avatarColor: Colors.indigo,
            unreadCount: 0,
            hasImage: true,
          ),
          _buildChatItem(
            context,
            name: 'Tech News',
            message: 'Latest updates in technology',
            time: 'Monday',
            avatar: Icons.newspaper,
            avatarColor: Colors.blueGrey,
            unreadCount: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(
    BuildContext context, {
    required String name,
    required String message,
    required String time,
    required IconData avatar,
    required Color avatarColor,
    required int unreadCount,
    bool hasImage = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: avatarColor.withValues(alpha: 0.2),
          child: Icon(avatar, color: avatarColor, size: 28),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  if (hasImage)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.image,
                        size: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// CONTACTS PAGE
class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSpecialItem(
            context,
            icon: Icons.group_add,
            title: 'New Group Chat',
            iconColor: Colors.green,
          ),
          _buildSpecialItem(
            context,
            icon: Icons.person_add,
            title: 'Add Contacts',
            iconColor: Colors.blue,
          ),
          _buildSpecialItem(
            context,
            icon: Icons.label,
            title: 'Tags',
            iconColor: Colors.orange,
          ),
          _buildSpecialItem(
            context,
            icon: Icons.people,
            title: 'Official Accounts',
            iconColor: Colors.purple,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Text(
              'A',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          _buildContactItem(
            context,
            name: 'Alice Wang',
            avatar: Icons.person,
            avatarColor: Colors.blue,
          ),
          _buildContactItem(
            context,
            name: 'Andrew Lee',
            avatar: Icons.person,
            avatarColor: Colors.cyan,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Text(
              'D',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          _buildContactItem(
            context,
            name: 'David Chen',
            avatar: Icons.person,
            avatarColor: Colors.teal,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Text(
              'E',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          _buildContactItem(
            context,
            name: 'Emma Wilson',
            avatar: Icons.person,
            avatarColor: Colors.indigo,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Text(
              'J',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          _buildContactItem(
            context,
            name: 'John Smith',
            avatar: Icons.person,
            avatarColor: Colors.blue,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Text(
              'S',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          _buildContactItem(
            context,
            name: 'Sarah Johnson',
            avatar: Icons.person,
            avatarColor: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color iconColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required String name,
    required IconData avatar,
    required Color avatarColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: avatarColor.withValues(alpha: 0.2),
          child: Icon(avatar, color: avatarColor, size: 24),
        ),
        title: Text(name, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

// DISCOVER PAGE
class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discover',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          _buildDiscoverItem(
            context,
            icon: Icons.article_outlined,
            title: 'Moments',
            iconColor: Colors.red,
            iconBgColor: Colors.red.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          _buildDiscoverItem(
            context,
            icon: Icons.camera_alt_outlined,
            title: 'Channels',
            iconColor: Colors.orange,
            iconBgColor: Colors.orange.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          _buildDiscoverItem(
            context,
            icon: Icons.video_library_outlined,
            title: 'Live',
            iconColor: Colors.purple,
            iconBgColor: Colors.purple.withValues(alpha: 0.2),
          ),
          _buildDiscoverItem(
            context,
            icon: Icons.explore_outlined,
            title: 'Search',
            iconColor: Colors.blue,
            iconBgColor: Colors.blue.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          _buildDiscoverItem(
            context,
            icon: Icons.people_outline,
            title: 'People Nearby',
            iconColor: Colors.green,
            iconBgColor: Colors.green.withValues(alpha: 0.2),
          ),
          _buildDiscoverItem(
            context,
            icon: Icons.qr_code_scanner,
            title: 'Scan',
            iconColor: Colors.teal,
            iconBgColor: Colors.teal.withValues(alpha: 0.2),
          ),
          _buildDiscoverItem(
            context,
            icon: Icons.shopping_bag_outlined,
            title: 'Shake',
            iconColor: Colors.cyan,
            iconBgColor: Colors.cyan.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          _buildDiscoverItem(
            context,
            icon: Icons.shopping_bag_outlined,
            title: 'Shop',
            iconColor: Colors.pink,
            iconBgColor: Colors.pink.withValues(alpha: 0.2),
          ),
          _buildDiscoverItem(
            context,
            icon: Icons.videogame_asset_outlined,
            title: 'Games',
            iconColor: Colors.deepOrange,
            iconBgColor: Colors.deepOrange.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          _buildDiscoverItem(
            context,
            icon: Icons.apps,
            title: 'Mini Programs',
            iconColor: Colors.indigo,
            iconBgColor: Colors.indigo.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

// PROFILE PAGE
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Me',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blue.withValues(alpha: 0.2),
                  child: const Icon(Icons.person, color: Colors.blue, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Name',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'WeChat ID: your_wechat_id',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.qr_code, size: 32),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildProfileItem(
            context,
            icon: Icons.payment,
            title: 'Services',
            iconColor: Colors.orange,
            iconBgColor: Colors.orange.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          _buildProfileItem(
            context,
            icon: Icons.favorite_outline,
            title: 'Favorites',
            iconColor: Colors.red,
            iconBgColor: Colors.red.withValues(alpha: 0.2),
          ),
          _buildProfileItem(
            context,
            icon: Icons.photo_library_outlined,
            title: 'Moments',
            iconColor: Colors.blue,
            iconBgColor: Colors.blue.withValues(alpha: 0.2),
          ),
          _buildProfileItem(
            context,
            icon: Icons.credit_card,
            title: 'Cards & Offers',
            iconColor: Colors.purple,
            iconBgColor: Colors.purple.withValues(alpha: 0.2),
          ),
          _buildProfileItem(
            context,
            icon: Icons.emoji_emotions_outlined,
            title: 'Sticker Gallery',
            iconColor: Colors.green,
            iconBgColor: Colors.green.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          _buildProfileItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            iconColor: Colors.blueGrey,
            iconBgColor: Colors.blueGrey.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

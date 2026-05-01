import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/widgets/app_app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/features/contacts/data/mocks/contact_mocks.dart';
import 'package:obywatel_plus/features/contacts/domain/models/ui_contact.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_bottom_nav.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_contact_card.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_fab.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_online_section.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_search_delegate.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  static const Color _bgDark = Color(0xFF0A0E27);
  static const Color _primaryNeon = Color(0xFF00F0FF);
  static const Color _accentNeon = Color(0xFFFF00F5);
  static const Color _successNeon = Color(0xFF00FF88);
  static const Color _surfaceColor = Color(0xFF1A1A2E);

  final List<UIContact> _contacts = ContactMocks.contacts;
  int _currentIndex = 0;

  void _showSearch() {
    showSearch(
      context: context,
      delegate: ContactsSearchDelegate(
        contacts: _contacts,
        surfaceColor: _surfaceColor,
        primaryNeon: _primaryNeon,
        successNeon: _successNeon,
        accentNeon: _accentNeon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: _bgDark,
      appBar: AppAppBar(
        title: 'Kontakty',
        onBackButtonPressed: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _showSearch,
          ),
        ],
      ),
      useSafeArea: true,
      scrollable: false,
      bottomNavigationBar: ContactsBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: ContactsFAB(
        onPressed: () {},
        backgroundColor: _bgDark,
        accentColor: _primaryNeon,
      ),
      child: CustomScrollView(
        slivers: [
          ContactsOnlineSection(
            contacts: _contacts,
            accentColor: _primaryNeon,
            successColor: _successNeon,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ContactsContactCard(
                contact: _contacts[index],
                surfaceColor: _surfaceColor,
                primaryNeon: _primaryNeon,
                successNeon: _successNeon,
                accentNeon: _accentNeon,
              ),
              childCount: _contacts.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

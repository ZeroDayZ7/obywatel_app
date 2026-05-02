import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/contacts/data/mocks/contact_mocks.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_contact_card.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_online_section.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  static const Color _primaryNeon = Color(0xFF00F0FF);
  static const Color _accentNeon = Color(0xFFFF00F5);
  static const Color _successNeon = Color(0xFF00FF88);
  static const Color _surfaceColor = Color(0xFF1A1A2E);

  @override
  Widget build(BuildContext context) {
    final contacts = ContactMocks.contacts;

    return CustomScrollView(
      slivers: [
        ContactsOnlineSection(
          contacts: contacts,
          accentColor: _primaryNeon,
          successColor: _successNeon,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ContactsContactCard(
              contact: contacts[index],
              surfaceColor: _surfaceColor,
              primaryNeon: _primaryNeon,
              successNeon: _successNeon,
              accentNeon: _accentNeon,
            ),
            childCount: contacts.length,
          ),
        ),
      ],
    );
  }
}

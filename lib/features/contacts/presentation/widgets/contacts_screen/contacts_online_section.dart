// lib/features/contacts/presentation/widgets/contacts_screen/contacts_online_section.dart
import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/contacts/domain/models/contact.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_online_avatar.dart';

class ContactsOnlineSection extends StatelessWidget {
  final List<Contact> contacts;

  const ContactsOnlineSection({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 88,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return ContactsOnlineAvatar(contact: contacts[index]);
          },
        ),
      ),
    );
  }
}

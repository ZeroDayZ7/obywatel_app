import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/contacts/domain/models/ui_contact.dart';

import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_online_avatar.dart';

class ContactsOnlineSection extends StatelessWidget {
  final List<UIContact> contacts;
  final Color accentColor;
  final Color successColor;

  const ContactsOnlineSection({
    super.key,
    required this.contacts,
    required this.accentColor,
    required this.successColor,
  });

  @override
  Widget build(BuildContext context) {
    final onlineOnes = contacts.where((c) => c.isOnline).toList();

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'DOSTĘPNI W SIECI',
              style: TextStyle(
                color: accentColor,
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: onlineOnes.length,
              itemBuilder: (context, index) => ContactsOnlineAvatar(
                contact: onlineOnes[index],
                successColor: successColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

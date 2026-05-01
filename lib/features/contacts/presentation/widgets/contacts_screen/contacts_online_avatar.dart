import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/contacts/domain/models/ui_contact.dart';

class ContactsOnlineAvatar extends StatelessWidget {
  final UIContact contact;
  final Color successColor;

  const ContactsOnlineAvatar({
    super.key,
    required this.contact,
    required this.successColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: successColor, width: 2),
              boxShadow: [
                BoxShadow(color: successColor.withAlpha(76), blurRadius: 10),
              ],
            ),
            child: Center(
              child: Text(
                contact.avatarInitials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            contact.name.split(' ')[0],
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

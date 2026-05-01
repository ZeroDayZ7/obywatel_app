import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/contacts/domain/models/ui_contact.dart';

class ContactsContactCard extends StatelessWidget {
  final UIContact contact;
  final Color surfaceColor;
  final Color primaryNeon;
  final Color successNeon;
  final Color accentNeon;

  const ContactsContactCard({
    super.key,
    required this.contact,
    required this.surfaceColor,
    required this.primaryNeon,
    required this.successNeon,
    required this.accentNeon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor.withAlpha(102),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: contact.glowColor.withAlpha(51),
                child: Text(
                  contact.avatarInitials,
                  style: TextStyle(color: contact.glowColor),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          contact.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (contact.isVerified)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.verified,
                              color: primaryNeon,
                              size: 14,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      contact.phone,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                color: Colors.white24,
                size: 16,
              ),
            ],
          ),
          const Divider(height: 24, color: Colors.white10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAction(CupertinoIcons.phone, successNeon),
              _buildAction(CupertinoIcons.lock_shield, primaryNeon),
              _buildAction(CupertinoIcons.paperplane, accentNeon),
              _buildAction(CupertinoIcons.delete, Colors.white24),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, Color color) {
    return Icon(icon, color: color, size: 20);
  }
}

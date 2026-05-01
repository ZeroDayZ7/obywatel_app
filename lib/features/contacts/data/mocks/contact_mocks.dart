import 'package:flutter/material.dart';

import '../../domain/models/ui_contact.dart';

class ContactMocks {
  static const Color primaryNeon = Color(0xFF00F0FF);
  static const Color accentNeon = Color(0xFFFF00F5);

  static final List<UIContact> contacts = [
    UIContact(
      id: '1',
      name: 'Anna Kowalska',
      phone: '+48 500 111 222',
      isOnline: true,
      isVerified: true,
      category: 'Ulubione',
      avatarInitials: 'AK',
      glowColor: primaryNeon,
    ),
    UIContact(
      id: '2',
      name: 'Jan Nowak',
      phone: '+48 600 333 444',
      isOnline: false,
      isVerified: true,
      category: 'Rodzina',
      avatarInitials: 'JN',
      glowColor: accentNeon,
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
      glowColor: primaryNeon,
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
}

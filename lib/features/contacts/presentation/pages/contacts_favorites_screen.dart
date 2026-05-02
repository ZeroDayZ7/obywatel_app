import 'package:flutter/material.dart';

class ContactsFavoritesScreen extends StatelessWidget {
  const ContactsFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Ulubione kontakty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Tu pojawią się Twoje przypięte osoby'),
        ],
      ),
    );
  }
}

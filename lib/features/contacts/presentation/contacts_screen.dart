// ignore_for_file: prefer_const_constructors_in_immutables, todo

import 'package:flutter/material.dart';
import '../data/contact_model.dart';

class ContactsScreen extends StatefulWidget {
  ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<Contact> mockContacts = [
    Contact(id: '1', name: 'Alice Smith', email: 'alice@example.com', phone: '+123456789'),
    Contact(id: '2', name: 'Bob Johnson', email: 'bob@example.com', phone: '+987654321'),
    Contact(id: '3', name: 'Charlie Brown', email: 'charlie@example.com', phone: '+192837465'),
  ];

  String searchQuery = '';
  int _currentIndex = 0;

  void _showAddContactModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.qr_code),
                title: Text('Scan QR Code'),
                onTap: () {
                  // TODO: implement QR scanning
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.person_search),
                title: Text('Search by ID'),
                onTap: () {
                  // TODO: implement search by ID
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.send),
                title: Text('Send Invite Link'),
                onTap: () {
                  // TODO: implement sending invite
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedContacts = [...mockContacts]..sort((a, b) => a.name.compareTo(b.name));
    final filteredContacts = sortedContacts
        .where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white24,
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: filteredContacts.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final contact = filteredContacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(contact.name[0], style: const TextStyle(color: Colors.white)),
            ),
            title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(contact.phone),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.phone, color: Colors.green),
                  onPressed: () {
                    // TODO: implement call action
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat, color: Colors.blue),
                  onPressed: () {
                    // TODO: open chat screen
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        // TODO: implement edit
                        break;
                      case 'delete':
                        // TODO: implement delete
                        break;
                      case 'details':
                        // TODO: navigate to contact details page
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'details', child: Text('Show Info')),
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            onTap: () {
              // TODO: navigate to contact detail page
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactModal,
        tooltip: 'Add Contact',
        child: const Icon(Icons.person_add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contacts'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          // TODO: handle navigation between tabs
        },
      ),
    );
  }
}

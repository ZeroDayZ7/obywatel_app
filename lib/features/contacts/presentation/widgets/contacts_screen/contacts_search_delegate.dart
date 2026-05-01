import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/contacts/domain/models/ui_contact.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_contact_card.dart';

class ContactsSearchDelegate extends SearchDelegate<UIContact?> {
  final List<UIContact> contacts;
  final Color surfaceColor;
  final Color primaryNeon;
  final Color successNeon;
  final Color accentNeon;

  ContactsSearchDelegate({
    required this.contacts,
    required this.surfaceColor,
    required this.primaryNeon,
    required this.successNeon,
    required this.accentNeon,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF0A0E27),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    final filtered = contacts
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: const Color(0xFF0A0E27),
      child: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          return ContactsContactCard(
            contact: filtered[index],
            surfaceColor: surfaceColor,
            primaryNeon: primaryNeon,
            successNeon: successNeon,
            accentNeon: accentNeon,
          );
        },
      ),
    );
  }
}

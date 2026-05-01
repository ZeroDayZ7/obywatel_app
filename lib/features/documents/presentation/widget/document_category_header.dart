import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/margins/app_margins.dart';

class DocumentCategoryHeader extends StatelessWidget {
  final String title;

  const DocumentCategoryHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: CardMargins.small,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

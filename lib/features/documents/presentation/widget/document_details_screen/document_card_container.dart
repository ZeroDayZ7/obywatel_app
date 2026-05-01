// widgets/document_card_container.dart
import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';

class DocumentCardContainer extends StatelessWidget {
  final DocumentModel doc;
  final Widget child;

  const DocumentCardContainer({
    super.key,
    required this.doc,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E2E), Color(0xFF2A2A3E)],
        ),
        boxShadow: [
          BoxShadow(
            color: doc.themeColor.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

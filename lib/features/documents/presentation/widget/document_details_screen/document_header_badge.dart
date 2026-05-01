import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';

class DocumentHeaderBadge extends StatelessWidget {
  final DocumentModel doc;
  const DocumentHeaderBadge({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: doc.themeColor.withAlpha(51),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: doc.themeColor.withAlpha(128)),
          ),
          child: Row(
            children: [
              Icon(Icons.verified_user, size: 16, color: doc.themeColor),
              const SizedBox(width: 6),
              const Text(
                'DOKUMENT WAŻNY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.more_vert, color: Colors.grey),
      ],
    );
  }
}

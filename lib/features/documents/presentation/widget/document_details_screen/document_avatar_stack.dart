import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';

class DocumentAvatarStack extends StatelessWidget {
  final DocumentModel doc;

  const DocumentAvatarStack({super.key, required this.doc});

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _parseColor(doc.colorHex);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: themeColor.withAlpha(128), width: 2),
          ),
          child: const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF2A2A3E),
            child: Icon(Icons.person, size: 50, color: Colors.white24),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: themeColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(77), blurRadius: 8),
              ],
            ),
            child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
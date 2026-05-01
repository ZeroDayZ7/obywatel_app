import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';

class DocumentSensitiveField extends StatelessWidget {
  final DocumentField field;
  final bool isVisible;
  final VoidCallback onToggle;

  const DocumentSensitiveField({
    super.key,
    required this.field,
    required this.isVisible,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                isVisible ? field.value : '•••••••••••',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: isVisible ? 1 : 4,
                ),
              ),
            ],
          ),
          if (!isVisible)
            IconButton(
              onPressed: onToggle,
              icon: const Icon(Icons.visibility_off, color: Colors.indigo),
            ),
        ],
      ),
    );
  }
}

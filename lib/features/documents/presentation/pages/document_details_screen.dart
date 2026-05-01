import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_avatar_stack.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_card_container.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_expiry_badge.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_header_badge.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_info_row.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_qr_section.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_sensitive_field.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/pin_verification_dialog.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final DocumentModel document;
  const DocumentDetailsScreen({super.key, required this.document});

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  bool _sensitiveVisible = false;

  void _handleSensitiveToggle() async {
    final verified = await PinVerificationDialog.show(context);
    if (verified) {
      setState(() => _sensitiveVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.document;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(doc.title),
        backgroundColor: const Color(0xFF1E1E2E),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DocumentCardContainer(
          doc: doc,
          child: Column(
            children: [
              DocumentHeaderBadge(doc: doc),
              const SizedBox(height: 24),
              DocumentAvatarStack(doc: doc),
              const SizedBox(height: 24),
              ...doc.fields.map(
                (field) => field.isSensitive
                    ? DocumentSensitiveField(
                        field: field,
                        isVisible: _sensitiveVisible,
                        onToggle: _handleSensitiveToggle,
                      )
                    : DocumentInfoRow(
                        icon: field.icon,
                        label: field.label,
                        value: field.value,
                      ),
              ),
              if (doc.expiryDate != null) ...[
                const SizedBox(height: 16),
                DocumentExpiryBadge(date: doc.expiryDate!),
              ],
              if (doc.qrData != null) DocumentQrSection(data: doc.qrData!),
            ],
          ),
        ),
      ),
    );
  }
}

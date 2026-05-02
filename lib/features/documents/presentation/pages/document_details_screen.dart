import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/documents/application/documents_provider.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_avatar_stack.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_card_container.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_expiry_badge.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_header_badge.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_info_row.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_qr_section.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_sensitive_field.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/pin_verification_dialog.dart';

class DocumentDetailsScreen extends ConsumerStatefulWidget {
  final String documentId;
  final DocumentModel? initialDocument;

  const DocumentDetailsScreen({
    super.key,
    required this.documentId,
    this.initialDocument,
  });

  @override
  ConsumerState<DocumentDetailsScreen> createState() =>
      _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends ConsumerState<DocumentDetailsScreen> {
  bool _sensitiveVisible = false;

  void _handleSensitiveToggle() async {
    final verified = await PinVerificationDialog.show(context);
    if (verified) {
      setState(() => _sensitiveVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final docAsync = ref.watch(documentDetailProvider(widget.documentId));

    return docAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Text(
            'Błąd: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      data: (doc) => Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: Text(doc.title),
          backgroundColor: const Color(0xFF1E1E2E),
          foregroundColor: Colors.white,
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
      ),
    );
  }
}

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/documents/application/documents_provider.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:obywatel_plus/features/documents/presentation/mappers/document_icon_mapper.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_avatar_stack.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_card_container.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_expiry_badge.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_header_badge.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_info_row.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/document_details_screen/document_qr_section.dart';

class DocumentDetailsScreen extends ConsumerWidget {
  final String documentId;
  final DocumentModel? initialDocument;

  const DocumentDetailsScreen({
    super.key,
    required this.documentId,
    this.initialDocument,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (initialDocument != null) {
      return _buildContent(context, initialDocument!);
    }

    final documentsState = ref.watch(documentsProvider);
    final cachedDoc = documentsState.value?.firstWhereOrNull(
      (doc) => doc.id == documentId,
    );

    if (cachedDoc != null) {
      return _buildContent(context, cachedDoc);
    }

    final docAsync = ref.watch(documentDetailProvider(documentId));

    return docAsync.when(
      loading: () => const AppScaffold(
        size: ContainerSize.medium,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => AppScaffold(
        size: ContainerSize.medium,
        child: Center(child: Text('Błąd pobierania dokumentu: $err')),
      ),
      data: (doc) {
        if (doc == null) {
          return const AppScaffold(
            size: ContainerSize.medium,
            child: Center(child: Text('Dokument nie został znaleziony')),
          );
        }
        return _buildContent(context, doc);
      },
    );
  }

  Widget _buildContent(BuildContext context, DocumentModel doc) {
    final expiryDate = doc.expiryDate;

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppAppBar(title: doc.title),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DocumentCardContainer(
          doc: doc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DocumentHeaderBadge(doc: doc),
              const SizedBox(height: 24),
              DocumentAvatarStack(doc: doc),
              const SizedBox(height: 24),
              ...doc.fields.map(
                (field) => DocumentInfoRow(
                  icon: DocumentIconMapper.getIcon(field.iconName),
                  label: field.label,
                  value: field.value,
                ),
              ),
              if (expiryDate != null && expiryDate.isNotEmpty) ...[
                const SizedBox(height: 16),
                DocumentExpiryBadge(date: expiryDate),
              ],
              if (doc.qrData != null) DocumentQrSection(data: doc.qrData!),
            ],
          ),
        ),
      ),
    );
  }
}
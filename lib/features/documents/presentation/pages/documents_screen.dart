import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/documents/application/documents_provider.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:obywatel_plus/features/documents/presentation/mappers/document_icon_mapper.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/documents_screen/document_card.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/documents_screen/document_category_header.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/documents_screen/ticket_tile.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/documents_screen/wide_document_card.dart';

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(documentsProvider);

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppAppBar(
        title: 'Dokumenty',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(documentsProvider.notifier).refresh(),
          ),
        ],
      ),
      child: documentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Błąd: $err')),
        data: (documents) => _DocumentsList(documents: documents),
      ),
    );
  }
}

class _DocumentsList extends ConsumerWidget {
  final List<DocumentModel> documents;
  const _DocumentsList({required this.documents});

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identityDocs = documents
        .where((d) => d.category == DocumentCategory.identity)
        .toList();
    final permissionsDocs = documents
        .where((d) => d.category == DocumentCategory.permissions)
        .toList();
    final educationDocs = documents
        .where((d) => d.category == DocumentCategory.education)
        .toList();
    final transportDocs = documents
        .where((d) => d.category == DocumentCategory.transport)
        .toList();

    return RefreshIndicator(
      onRefresh: () => ref.read(documentsProvider.notifier).refresh(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (identityDocs.isNotEmpty) ...[
            const DocumentCategoryHeader(title: 'Tożsamość i Obywatelstwo'),
            _DocumentGrid(docs: identityDocs),
          ],
          if (permissionsDocs.isNotEmpty) ...[
            const DocumentCategoryHeader(title: 'Uprawnienia i Praca'),
            _DocumentGrid(docs: permissionsDocs),
          ],
          if (educationDocs.isNotEmpty) ...[
            const DocumentCategoryHeader(title: 'Edukacja'),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final doc = educationDocs[index];
                return WideDocumentCard(
                  title: doc.title,
                  subtitle: doc.subtitle,
                  expiry: doc.expiryDate.isNotEmpty
                      ? 'Ważna do ${doc.expiryDate}'
                      : '',
                  icon: DocumentIconMapper.getIcon(doc.iconName),
                  color: _parseColor(doc.colorHex),
                  onTap: () => context.push(
                    '${AppRoutes.documents}/detail/${doc.id}',
                    extra: doc,
                  ),
                );
              }, childCount: educationDocs.length),
            ),
          ],
          if (transportDocs.isNotEmpty) ...[
            const DocumentCategoryHeader(title: 'Transport i Podróże'),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final doc = transportDocs[index];
                return TicketTile(
                  title: doc.title,
                  subtitle: doc.subtitle,
                  icon: DocumentIconMapper.getIcon(doc.iconName),
                  color: _parseColor(doc.colorHex),
                  onTap: () => context.push(
                    '${AppRoutes.documents}/detail/${doc.id}',
                    extra: doc,
                  ),
                );
              }, childCount: transportDocs.length),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _DocumentGrid extends StatelessWidget {
  final List<DocumentModel> docs;
  const _DocumentGrid({required this.docs});

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 160 / 115,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final doc = docs[index];
        return DocumentCard(
          title: doc.title,
          icon: DocumentIconMapper.getIcon(doc.iconName),
          color: _parseColor(doc.colorHex),
          isVerified: doc.isVerified,
          status: doc.status,
          onTap: () => context.push(
            '${AppRoutes.documents}/detail/${doc.id}',
            extra: doc,
          ),
        );
      }, childCount: docs.length),
    );
  }
}
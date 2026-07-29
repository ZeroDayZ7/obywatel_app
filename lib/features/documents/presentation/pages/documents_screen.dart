import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/core/errors/failures/app_failure.dart';
import 'package:obywatel_plus/core/errors/presentation/error_message.dart';
import 'package:obywatel_plus/features/documents/application/documents_provider.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:obywatel_plus/features/documents/presentation/mappers/document_icon_mapper.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/documents_screen/document_card.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/documents_screen/document_category_header.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/documents_screen/ticket_tile.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/documents_screen/wide_document_card.dart';

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  Future<void> _handleRefresh(WidgetRef ref) async {
    await ref.read(documentsProvider.notifier).sync();
    ref.invalidate(documentsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(documentsProvider);

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppBar(
        title: const Text('Dokumenty'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: LocaleKeys.common_refresh.tr(),
            onPressed: () => _handleRefresh(ref),
          ),
        ],
      ),
      child: documentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          final failureMessage = error is AppFailure
              ? error.messageKey.tr()
              : LocaleKeys.errors_unexpected_error.tr();

          return ErrorMessage(
            message: failureMessage,
            onRetry: () => _handleRefresh(ref),
          );
        },
        data: (documents) => _DocumentsList(
          documents: documents,
          onRefresh: () => _handleRefresh(ref),
        ),
      ),
    );
  }
}

class _DocumentsList extends StatelessWidget {
  final List<DocumentModel> documents;
  final Future<void> Function() onRefresh;

  const _DocumentsList({required this.documents, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            alignment: Alignment.center,
            child: const Text('Brak dostępnych dokumentów'),
          ),
        ),
      );
    }

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
    final socialDocs = documents
        .where((d) => d.category == DocumentCategory.social)
        .toList();
    final otherDocs = documents
        .where((d) => d.category == DocumentCategory.other)
        .toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
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
          if (socialDocs.isNotEmpty) ...[
            const DocumentCategoryHeader(title: 'Usługi Społeczne'),
            _DocumentGrid(docs: socialDocs),
          ],
          if (educationDocs.isNotEmpty) ...[
            const DocumentCategoryHeader(title: 'Edukacja'),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final doc = educationDocs[index];
                final expiry = doc.expiryDate;
                return WideDocumentCard(
                  title: doc.title,
                  subtitle: doc.subtitle,
                  expiry: (expiry != null && expiry.isNotEmpty)
                      ? 'Ważna do $expiry'
                      : '',
                  icon: DocumentIconMapper.getIcon(doc.iconName),
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
                  onTap: () => context.push(
                    '${AppRoutes.documents}/detail/${doc.id}',
                    extra: doc,
                  ),
                );
              }, childCount: transportDocs.length),
            ),
          ],
          if (otherDocs.isNotEmpty) ...[
            const DocumentCategoryHeader(title: 'Pozostałe'),
            _DocumentGrid(docs: otherDocs),
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

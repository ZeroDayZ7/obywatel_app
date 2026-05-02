// lib/app/router/routes/documents_routes.dart
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';
import 'package:obywatel_plus/features/documents/presentation/pages/document_details_screen.dart';
import 'package:obywatel_plus/features/documents/presentation/pages/documents_screen.dart';

final documentsRoutes = [
  AppRoutes.documents.go(
    const DocumentsScreen(),
    routes: [
      'detail/:id'.goWithState((state) {
        final id = state.pathParameters['id']!;
        final doc = state.extra as DocumentModel?;

        return DocumentDetailsScreen(documentId: id, initialDocument: doc);
      }),
    ],
  ),
];

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
      AppRoutes.idCard.goWithState((state) {
        final doc = state.extra as DocumentModel;
        return DocumentDetailsScreen(document: doc);
      }),
    ],
  ),
];

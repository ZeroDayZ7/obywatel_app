// lib/app/router/routes/documents_routes.dart
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/documents/presentation/screens/documents_home.dart';
import 'package:obywatel_plus/features/documents/presentation/screens/id_card_screen.dart';

final documentsRoutes = [
  AppRoutes.documents.go(
    const DocumentsScreen(),
    routes: [AppRoutes.idCard.go(const IDCardScreen())],
  ),
];

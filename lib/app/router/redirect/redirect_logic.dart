// redirect_logic.dart
// lib/app/router/redirect/redirect_logic.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/redirect/redirect_guards.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';

String? appRedirectLogic(Ref ref, GoRouterState state) {
  final logger = ref.read(appLoggerProvider);

  logger.d('[Router Guard] Redirect check for: ${state.uri.path}');

  // Kolejność ma znaczenie!
  final guards = [rootGuard];

  for (final guard in guards) {
    final redirect = guard(ref, state);
    if (redirect != null) {
      logger.i('Redirect → $redirect');
      return redirect;
    }
  }

  logger.d('[Router Guard] No redirect needed');
  return null;
}

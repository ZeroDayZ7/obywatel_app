import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/features/settings/presentation/config/security_settings_config.dart';
import 'package:obywatel_plus/features/settings/presentation/pages/change_pin_screen.dart';

class _FixedSecurityService extends SecurityService {
  @override
  SecurityState build() => const SecurityState(
    hasLocalLock: false,
    isPinConfigured: false,
    isBiometricEnabled: false,
    canUseBiometrics: false,
    isSetupCompleted: true,
    initialized: true,
    localSecurityMethod: LocalSecurityMethod.password,
  );
}

void main() {
  test(
    'security settings generate distinct routes for active method and local secret change',
    () {
      expect(
        SecuritySettingsConfig.buildChangeMethodPath(LocalSecurityMethod.password),
        '${AppRoutes.settings}/${AppRoutes.settingsChangePin}?mode=change_method&method=password',
      );

      expect(
        SecuritySettingsConfig.buildChangeSecretPath(LocalSecurityMethod.password),
        '${AppRoutes.settings}/${AppRoutes.settingsChangePin}?mode=change_secret&method=password',
      );

      expect(
        SecuritySettingsConfig.buildChangeMethodPath(LocalSecurityMethod.pin),
        '${AppRoutes.settings}/${AppRoutes.settingsChangePin}?mode=change_method&method=pin',
      );
    },
  );

  testWidgets(
    'active method click on same method is a no-op',
    (tester) async {
      final router = GoRouter(
        initialLocation: '${AppRoutes.settings}/${AppRoutes.settingsChangePin}?mode=change_method&method=password',
        routes: [
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, _) => const SizedBox(),
            routes: [
              GoRoute(
                path: AppRoutes.settingsChangePin,
                builder: (_, _) => const ChangePinScreen(),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            securityServiceProvider.overrideWith(() => _FixedSecurityService()),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Wybierz aktywną metodę lokalnego odblokowania'), findsOneWidget);

      await tester.tap(find.text('Hasło lokalne'));
      await tester.pumpAndSettle();

      expect(find.text('Wybierz aktywną metodę lokalnego odblokowania'), findsOneWidget);
      expect(find.text('Ustaw nowe hasło lokalne'), findsNothing);
    },
  );

  testWidgets(
    'switching from password to PIN starts with new PIN setup, not password setup',
    (tester) async {
      final router = GoRouter(
        initialLocation: '${AppRoutes.settings}/${AppRoutes.settingsChangePin}?mode=change_method&method=password',
        routes: [
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, _) => const SizedBox(),
            routes: [
              GoRoute(
                path: AppRoutes.settingsChangePin,
                builder: (_, _) => const ChangePinScreen(),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            securityServiceProvider.overrideWith(() => _FixedSecurityService()),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Wybierz aktywną metodę lokalnego odblokowania'), findsOneWidget);
      await tester.tap(find.text('PIN'));
      await tester.pumpAndSettle();

      expect(find.text('Wybierz aktywną metodę lokalnego odblokowania'), findsNothing);
      expect(find.text('Ustaw nowe hasło lokalne'), findsNothing);
    },
  );
}

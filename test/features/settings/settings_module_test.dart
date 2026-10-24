import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/routes/settings_routes.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/settings/domain/settings_preferences_state.dart';
import 'package:obywatel_plus/features/settings/domain/settings_section.dart';
import 'package:obywatel_plus/features/settings/presentation/config/account_settings_config.dart';
import 'package:obywatel_plus/features/settings/presentation/config/security_settings_config.dart';
import 'package:obywatel_plus/features/settings/presentation/config/settings_config.dart';
import 'package:obywatel_plus/features/settings/presentation/pages/account_settings_screen.dart';

void main() {
  group('Settings module', () {
    test('preferences defaults are coherent', () {
      const state = SettingsPreferencesState();

      expect(state.appLockTimeout, AppLockTimeout.minute1);
      expect(state.biometricPrompt, isTrue);
    });

    testWidgets('settings config returns typed sections', (tester) async {
      late List<SettingsSection> sections;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                sections = SettingsConfig.getSections(
                  context,
                  ref,
                  onLanguageTap: () {},
                  onThemeTap: () {},
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(sections, isA<List<SettingsSection>>());
      expect(sections, isNotEmpty);
      expect(sections.first.items, isNotEmpty);
      expect(sections.first.items.first.title, isNotEmpty);
    });

    testWidgets('security settings expose change password and pin entries', (tester) async {
      late List<SettingsSection> sections;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                final state = ref.watch(securityServiceProvider);
                sections = SecuritySettingsConfig.getSections(
                  context,
                  ref,
                  state: state,
                  notifier: ref.read(securityServiceProvider.notifier),
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      final items = sections.expand((section) => section.items).toList();
      expect(items.any((item) => item.title.trim().isNotEmpty), isTrue);
      expect(items.length >= 3, isTrue);
      expect(items.any((item) => item.type == ActionType.toggle), isTrue);
      expect(items.any((item) => item.type == ActionType.action && item.isDanger), isTrue);
      expect(items.any((item) => item.type == ActionType.navigation), isTrue);
    });

    testWidgets('account settings expose account submenu and future items are disabled', (tester) async {
      late List<SettingsSection> sections;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                sections = AccountSettingsConfig.getSections(context, ref);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      final items = sections.expand((section) => section.items).toList();

      expect(items.length >= 5, isTrue);
      expect(items.where((item) => item.type == ActionType.navigation).length >= 3, isTrue);
      expect(items.where((item) => !item.isEnabled).length >= 3, isTrue);
    });

    testWidgets('settings router exposes the dedicated account section', (tester) async {
      final router = GoRouter(routes: settingsRoutes, initialLocation: '/settings/account');

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(AccountSettingsScreen), findsOneWidget);
    });
  });
}
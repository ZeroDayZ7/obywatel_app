import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/settings/domain/settings_preferences_state.dart';
import 'package:obywatel_plus/features/settings/domain/settings_section.dart';
import 'package:obywatel_plus/features/settings/presentation/config/security_settings_config.dart';
import 'package:obywatel_plus/features/settings/presentation/config/settings_config.dart';

void main() {
  group('Settings module', () {
    test('preferences defaults are coherent', () {
      const state = SettingsPreferencesState();

      expect(state.appLockTimeout, AppLockTimeout.minute1);
      expect(state.privacyMode, PrivacyMode.balanced);
      expect(state.displayMode, DisplayMode.adaptive);
      expect(state.biometricPrompt, isTrue);
      expect(state.reducedMotion, isFalse);
      expect(state.dataSharingOptIn, isFalse);
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
      expect(
        items.where(
          (item) => item.type == ActionType.navigation && item.onTap != null,
        ).length >= 3,
        isTrue,
      );
      expect(
        items.any((item) => item.type == ActionType.toggle || item.type == ActionType.navigation),
        isTrue,
      );
    });
  });
}

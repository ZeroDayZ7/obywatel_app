import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/application/messaging_activation_controller.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';

void main() {
  group('MessagingActivationState persistence', () {
    test('round-trips active state and keeps onboarding hidden', () {
      final original = MessagingActivationState(
        status: const MessagingActivationDto(
          userId: 'user-1',
          status: 'active',
          consentAccepted: true,
          termsVersion: 'v2',
          currentTermsVersion: 'v2',
          requiresTermsAcceptance: false,
        ),
        terms: const MessagingTermsDto(
          version: 'v2',
          text: 'Regulamin komunikatora',
        ),
      );

      final json = original.toJson();
      final restored = MessagingActivationState.fromJson(json);

      expect(restored.isActive, isTrue);
      expect(restored.shouldShowOnboarding, isFalse);
      expect(restored.status?.status, equals(original.status?.status));
      expect(restored.terms?.version, equals(original.terms?.version));
    });

    test('empty state still requires onboarding', () {
      const state = MessagingActivationState();

      expect(state.shouldShowOnboarding, isTrue);
    });
  });
}

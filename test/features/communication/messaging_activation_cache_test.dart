import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';
import 'package:obywatel_plus/features/communication/domain/models/messaging_activation_state.dart';

void main() {
  group('MessagingActivationState', () {
    test('round-trips active state and keeps onboarding hidden', () {
      const original = MessagingActivationState(
        status: MessagingActivationDto(
          userId: 'user-1',
          status: 'active',
          consentAccepted: true,
          termsVersion: 'v2',
          currentTermsVersion: 'v2',
          requiresTermsAcceptance: false,
        ),
        terms: MessagingTermsDto(
          version: 'v2',
          text: 'Regulamin komunikatora',
        ),
      );

      final restored = original.copyWith();

      expect(restored.isActive, isTrue);
      expect(restored.shouldShowOnboarding, isFalse);
      expect(restored.status?.status, equals(original.status?.status));
      expect(restored.terms?.version, equals(original.terms?.version));
    });

    test('empty state still requires onboarding', () {
      const state = MessagingActivationState();

      expect(state.shouldShowOnboarding, isTrue);
    });

    test('copyWith clears the status and terms when null is passed explicitly', () {
      const original = MessagingActivationState(
        status: MessagingActivationDto(
          userId: 'user-1',
          status: 'active',
          consentAccepted: true,
          termsVersion: 'v2',
          currentTermsVersion: 'v2',
          requiresTermsAcceptance: false,
        ),
        terms: MessagingTermsDto(
          version: 'v2',
          text: 'Regulamin komunikatora',
        ),
      );

      final cleared = original.copyWith(status: null, terms: null, errorMessage: null);

      expect(cleared.status, isNull);
      expect(cleared.terms, isNull);
      expect(cleared.errorMessage, isNull);
    });
  });
}

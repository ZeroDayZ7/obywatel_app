import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/domain/models/messaging_activation_state.dart';

void main() {
  group('MessagingActivationState', () {
    test('active local activation stays hidden from onboarding', () {
      const state = MessagingActivationState(
        status: 'active',
        consentAccepted: true,
        hasLocalActivation: true,
        keyRegistrationStatus: 'completed',
      );

      expect(state.isActive, isTrue);
      expect(state.shouldShowOnboarding, isFalse);
    });

    test('empty state still requires onboarding', () {
      const state = MessagingActivationState();

      expect(state.shouldShowOnboarding, isTrue);
    });

    test('copyWith clears the error message without touching active state', () {
      const original = MessagingActivationState(
        status: 'active',
        consentAccepted: true,
        hasLocalActivation: true,
        errorMessage: 'temporary error',
      );

      final cleared = original.copyWith(errorMessage: null);

      expect(cleared.status, 'active');
      expect(cleared.consentAccepted, isTrue);
      expect(cleared.hasLocalActivation, isTrue);
      expect(cleared.errorMessage, isNull);
    });

    test('persisted confirmed activation is considered active without backend sync', () {
      const state = MessagingActivationState(
        status: 'active',
        consentAccepted: true,
        hasLocalActivation: true,
        keyRegistrationStatus: 'completed',
      );

      expect(state.isActive, isTrue);
      expect(state.shouldShowOnboarding, isFalse);
    });

    test('offline state without local activation must not become active', () {
      const state = MessagingActivationState(
        status: null,
        consentAccepted: false,
        hasLocalActivation: false,
        keyRegistrationStatus: 'not_started',
      );

      expect(state.isActive, isFalse);
      expect(state.shouldShowOnboarding, isTrue);
    });

    test('current terms version remains distinct from accepted version', () {
      const state = MessagingActivationState(
        status: 'active',
        consentAccepted: true,
        termsVersion: 'v1',
        currentTermsVersion: 'v2',
        hasLocalActivation: true,
        keyRegistrationStatus: 'completed',
      );

      expect(state.termsVersion, 'v1');
      expect(state.currentTermsVersion, 'v2');
    });

    test('state with no real terms text must not be treated as accepted', () {
      const state = MessagingActivationState(
        status: 'not_started',
        consentAccepted: false,
        hasLocalActivation: false,
        termsText: '',
        keyRegistrationStatus: 'not_started',
      );

      expect(state.isActive, isFalse);
      expect(state.shouldShowOnboarding, isTrue);
    });
  });
}

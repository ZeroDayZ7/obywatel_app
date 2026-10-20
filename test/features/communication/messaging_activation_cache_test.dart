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
  });
}

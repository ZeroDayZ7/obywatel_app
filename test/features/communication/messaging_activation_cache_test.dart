import 'package:flutter_test/flutter_test.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/features/communication/domain/crypto/e2ee_models.dart';
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

    test('hasUsableTerms requires a real current terms version, not accepted one', () {
      const state = MessagingActivationState(
        status: 'active',
        consentAccepted: true,
        termsText: 'Treść regulaminu',
        termsVersion: 'v1',
        currentTermsVersion: '',
        hasLocalActivation: true,
        keyRegistrationStatus: 'completed',
      );

      expect(state.hasUsableTerms, isFalse);
      expect(state.isActive, isTrue);
    });
  });

  group('SignalCiphertextEnvelope', () {
    test('accepts a valid ciphertext envelope', () {
      final envelope = SignalCiphertextEnvelope.fromJson({
        'type': CiphertextMessage.prekeyType,
        'ciphertext': 'Zm9v',
        'senderDeviceId': 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
        'recipientUserId': 'user-42',
        'recipientDeviceId': '7',
      });

      expect(envelope.type, CiphertextMessage.prekeyType);
      expect(envelope.recipientDeviceId, '7');
    });

    test('rejects missing or invalid recipient device id', () {
      expect(
        () => SignalCiphertextEnvelope.fromJson({
          'type': CiphertextMessage.whisperType,
          'ciphertext': 'Zm9v',
          'senderDeviceId': 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
          'recipientUserId': 'user-42',
          'recipientDeviceId': '0',
        }),
        throwsFormatException,
      );

      expect(
        () => SignalCiphertextEnvelope.fromJson({
          'type': CiphertextMessage.whisperType,
          'ciphertext': 'Zm9v',
          'senderDeviceId': 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
          'recipientUserId': 'user-42',
        }),
        throwsFormatException,
      );
    });
  });
}

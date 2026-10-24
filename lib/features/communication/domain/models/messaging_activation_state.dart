import 'package:freezed_annotation/freezed_annotation.dart';

part 'messaging_activation_state.freezed.dart';
part 'messaging_activation_state.g.dart';

@freezed
abstract class MessagingActivationState with _$MessagingActivationState {
  const MessagingActivationState._();

  const factory MessagingActivationState({
    String? userId,
    String? deviceId,
    String? status,
    @Default(false) bool consentAccepted,
    String? termsVersion,
    String? currentTermsVersion,
    @Default(false) bool requiresTermsAcceptance,
    String? termsText,
    @Default(false) bool hasLocalActivation,
    String? errorMessage,
    @Default('not_started') String keyRegistrationStatus,
  }) = _MessagingActivationState;

  bool get isActive =>
      hasLocalActivation && status == 'active' && consentAccepted == true;

  bool get hasUsableTerms =>
      (termsText ?? '').trim().isNotEmpty &&
      (currentTermsVersion ?? '').trim().isNotEmpty;

  bool get shouldShowOnboarding => !hasLocalActivation || !isActive;

  factory MessagingActivationState.fromJson(Map<String, dynamic> json) =>
      _$MessagingActivationStateFromJson(json);
}

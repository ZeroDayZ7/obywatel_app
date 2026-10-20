import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';

part 'messaging_activation_state.freezed.dart';
part 'messaging_activation_state.g.dart';

@freezed
abstract class MessagingActivationState with _$MessagingActivationState {
  const MessagingActivationState._();

  const factory MessagingActivationState({
    MessagingActivationDto? status,
    MessagingTermsDto? terms,
    String? errorMessage,
    @Default('not_started') String keyRegistrationStatus,
  }) = _MessagingActivationState;

  bool get isActive =>
      status != null &&
      status!.status == 'active' &&
      status!.consentAccepted == true;

  bool get shouldShowOnboarding {
    if (status == null && terms == null && errorMessage != null) {
      return false;
    }

    if (status == null && terms == null) {
      return true;
    }

    if (isActive) {
      return false;
    }

    final currentTermsVersion =
        status?.currentTermsVersion ?? terms?.version ?? '';
    final acceptedVersion = status?.termsVersion ?? '';

    return status == null ||
        status!.status == 'not_started' ||
        status!.requiresTermsAcceptance ||
        acceptedVersion != currentTermsVersion;
  }

  factory MessagingActivationState.fromJson(Map<String, dynamic> json) =>
      _$MessagingActivationStateFromJson(json);
}

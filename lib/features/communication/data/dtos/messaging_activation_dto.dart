import 'package:freezed_annotation/freezed_annotation.dart';

part 'messaging_activation_dto.freezed.dart';
part 'messaging_activation_dto.g.dart';

@freezed
abstract class MessagingActivationDto with _$MessagingActivationDto {
  const factory MessagingActivationDto({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'consent_accepted') @Default(false) bool consentAccepted,
    @JsonKey(name: 'terms_version') @Default('') String termsVersion,
    @JsonKey(name: 'current_terms_version') @Default('') String currentTermsVersion,
    @JsonKey(name: 'requires_terms_acceptance')
    @Default(false)
    bool requiresTermsAcceptance,
    @JsonKey(name: 'device_id') String? deviceId,
    @JsonKey(name: 'activated_at') DateTime? activatedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _MessagingActivationDto;

  factory MessagingActivationDto.fromJson(Map<String, dynamic> json) =>
      _$MessagingActivationDtoFromJson(json);
}

@freezed
abstract class MessagingTermsDto with _$MessagingTermsDto {
  const factory MessagingTermsDto({
    required String version,
    required String text,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
  }) = _MessagingTermsDto;

  factory MessagingTermsDto.fromJson(Map<String, dynamic> json) =>
      _$MessagingTermsDtoFromJson(json);
}

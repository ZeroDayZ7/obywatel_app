import 'package:freezed_annotation/freezed_annotation.dart';

part 'messaging_activation_dto.freezed.dart';
part 'messaging_activation_dto.g.dart';

@freezed
abstract class MessagingActivationDto with _$MessagingActivationDto {
  const factory MessagingActivationDto({
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'consentAccepted') @Default(false) bool consentAccepted,
    @JsonKey(name: 'termsVersion') @Default('') String termsVersion,
    @JsonKey(name: 'currentTermsVersion') @Default('') String currentTermsVersion,
    @JsonKey(name: 'requiresTermsAcceptance')
    @Default(false)
    bool requiresTermsAcceptance,
    @JsonKey(name: 'deviceId') String? deviceId,
    @JsonKey(name: 'activatedAt') DateTime? activatedAt,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
  }) = _MessagingActivationDto;

  factory MessagingActivationDto.fromJson(Map<String, dynamic> json) =>
      _$MessagingActivationDtoFromJson(json);
}

@freezed
abstract class MessagingTermsDto with _$MessagingTermsDto {
  const factory MessagingTermsDto({
    required String version,
    required String text,
    @JsonKey(name: 'publishedAt') DateTime? publishedAt,
  }) = _MessagingTermsDto;

  factory MessagingTermsDto.fromJson(Map<String, dynamic> json) =>
      _$MessagingTermsDtoFromJson(json);
}

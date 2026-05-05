import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_offer.freezed.dart';
part 'job_offer.g.dart';

@freezed
sealed class JobOffer with _$JobOffer {
  const factory JobOffer({
    required String id,
    required String title,
    required String company,
    required String location,
    required String salary,
    required String type,
  }) = _JobOffer;

  factory JobOffer.fromJson(Map<String, dynamic> json) =>
      _$JobOfferFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/work_and_career/domain/job_offer.dart';

part 'job_offers_state.freezed.dart';

@freezed
class JobOffersState with _$JobOffersState {
  const factory JobOffersState.initial() = _Initial;
  const factory JobOffersState.loading() = _Loading;
  const factory JobOffersState.data(List<JobOffer> offers) = _Data;
  const factory JobOffersState.error(String message) = _Error;
}
import 'package:obywatel_plus/features/work_and_career/domain/job_offer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_offers_notifier.g.dart';

@riverpod
class JobOffersNotifier extends _$JobOffersNotifier {
  @override
  Future<List<JobOffer>> build() async {
    return _fetch();
  }

  Future<List<JobOffer>> _fetch() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      JobOffer(
        id: '1',
        title: 'Flutter Developer',
        company: 'Tech Solutions',
        location: 'Warsaw',
        salary: '15k-20k',
        type: 'Full-time',
      ),
      JobOffer(
        id: '2',
        title: 'Backend Engineer',
        company: 'Innovatech',
        location: 'Krakow',
        salary: '18k-25k',
        type: 'Full-time',
      ),
    ];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

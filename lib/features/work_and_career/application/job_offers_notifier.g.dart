// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_offers_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(JobOffersNotifier)
final jobOffersProvider = JobOffersNotifierProvider._();

final class JobOffersNotifierProvider
    extends $AsyncNotifierProvider<JobOffersNotifier, List<JobOffer>> {
  JobOffersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobOffersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobOffersNotifierHash();

  @$internal
  @override
  JobOffersNotifier create() => JobOffersNotifier();
}

String _$jobOffersNotifierHash() => r'522fee5ccc2fa22fcb760514bb02d42fb71fbb7e';

abstract class _$JobOffersNotifier extends $AsyncNotifier<List<JobOffer>> {
  FutureOr<List<JobOffer>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<JobOffer>>, List<JobOffer>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<JobOffer>>, List<JobOffer>>,
              AsyncValue<List<JobOffer>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

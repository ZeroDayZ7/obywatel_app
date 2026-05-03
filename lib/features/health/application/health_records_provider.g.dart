// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_records_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HealthRecordsNotifier)
final healthRecordsProvider = HealthRecordsNotifierFamily._();

final class HealthRecordsNotifierProvider
    extends $AsyncNotifierProvider<HealthRecordsNotifier, List<HealthRecord>> {
  HealthRecordsNotifierProvider._({
    required HealthRecordsNotifierFamily super.from,
    required HealthRecordType super.argument,
  }) : super(
         retry: null,
         name: r'healthRecordsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$healthRecordsNotifierHash();

  @override
  String toString() {
    return r'healthRecordsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  HealthRecordsNotifier create() => HealthRecordsNotifier();

  @override
  bool operator ==(Object other) {
    return other is HealthRecordsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$healthRecordsNotifierHash() =>
    r'b2049792b3fbf955f1771d4ac17008a3ae558561';

final class HealthRecordsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          HealthRecordsNotifier,
          AsyncValue<List<HealthRecord>>,
          List<HealthRecord>,
          FutureOr<List<HealthRecord>>,
          HealthRecordType
        > {
  HealthRecordsNotifierFamily._()
    : super(
        retry: null,
        name: r'healthRecordsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HealthRecordsNotifierProvider call(HealthRecordType type) =>
      HealthRecordsNotifierProvider._(argument: type, from: this);

  @override
  String toString() => r'healthRecordsProvider';
}

abstract class _$HealthRecordsNotifier
    extends $AsyncNotifier<List<HealthRecord>> {
  late final _$args = ref.$arg as HealthRecordType;
  HealthRecordType get type => _$args;

  FutureOr<List<HealthRecord>> build(HealthRecordType type);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<HealthRecord>>, List<HealthRecord>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<HealthRecord>>, List<HealthRecord>>,
              AsyncValue<List<HealthRecord>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

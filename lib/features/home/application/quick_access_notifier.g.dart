// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_access_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuickAccessNotifier)
final quickAccessProvider = QuickAccessNotifierProvider._();

final class QuickAccessNotifierProvider
    extends $NotifierProvider<QuickAccessNotifier, List<QuickAccessItem>> {
  QuickAccessNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickAccessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quickAccessNotifierHash();

  @$internal
  @override
  QuickAccessNotifier create() => QuickAccessNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<QuickAccessItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<QuickAccessItem>>(value),
    );
  }
}

String _$quickAccessNotifierHash() =>
    r'd69a4f3396368cc340a44bb67f274e8043384a80';

abstract class _$QuickAccessNotifier extends $Notifier<List<QuickAccessItem>> {
  List<QuickAccessItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<QuickAccessItem>, List<QuickAccessItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<QuickAccessItem>, List<QuickAccessItem>>,
              List<QuickAccessItem>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_preferences_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsPreferencesNotifier)
final settingsPreferencesProvider = SettingsPreferencesNotifierProvider._();

final class SettingsPreferencesNotifierProvider
    extends
        $NotifierProvider<
          SettingsPreferencesNotifier,
          SettingsPreferencesState
        > {
  SettingsPreferencesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsPreferencesNotifierHash();

  @$internal
  @override
  SettingsPreferencesNotifier create() => SettingsPreferencesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsPreferencesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsPreferencesState>(value),
    );
  }
}

String _$settingsPreferencesNotifierHash() =>
    r'5ed9f8fc8a2ee9ca4780f0c9a55595f063885a02';

abstract class _$SettingsPreferencesNotifier
    extends $Notifier<SettingsPreferencesState> {
  SettingsPreferencesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<SettingsPreferencesState, SettingsPreferencesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingsPreferencesState, SettingsPreferencesState>,
              SettingsPreferencesState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

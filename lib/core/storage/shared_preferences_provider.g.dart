// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider dla instancji SharedPreferences (używany przy inicjalizacji)

@ProviderFor(sharedPreferencesInstance)
final sharedPreferencesInstanceProvider = SharedPreferencesInstanceProvider._();

/// Provider dla instancji SharedPreferences (używany przy inicjalizacji)

final class SharedPreferencesInstanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  /// Provider dla instancji SharedPreferences (używany przy inicjalizacji)
  SharedPreferencesInstanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesInstanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesInstanceHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferencesInstance(ref);
  }
}

String _$sharedPreferencesInstanceHash() =>
    r'6296d4ce57a982463624e15978f0ca3f80af87a5';

/// Aktywny serwis (wymaga override w ProviderScope w main.dart po załadowaniu instancji)

@ProviderFor(activePrefs)
final activePrefsProvider = ActivePrefsProvider._();

/// Aktywny serwis (wymaga override w ProviderScope w main.dart po załadowaniu instancji)

final class ActivePrefsProvider
    extends
        $FunctionalProvider<
          SharedPreferencesService,
          SharedPreferencesService,
          SharedPreferencesService
        >
    with $Provider<SharedPreferencesService> {
  /// Aktywny serwis (wymaga override w ProviderScope w main.dart po załadowaniu instancji)
  ActivePrefsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activePrefsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activePrefsHash();

  @$internal
  @override
  $ProviderElement<SharedPreferencesService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferencesService create(Ref ref) {
    return activePrefs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferencesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferencesService>(value),
    );
  }
}

String _$activePrefsHash() => r'd69df393fc2bf5ff9a87f81c34a3b0c37c1b106b';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThemeNotifier)
final themeProvider = ThemeNotifierProvider._();

final class ThemeNotifierProvider
    extends $NotifierProvider<ThemeNotifier, AppThemeType> {
  ThemeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeNotifierHash();

  @$internal
  @override
  ThemeNotifier create() => ThemeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppThemeType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppThemeType>(value),
    );
  }
}

String _$themeNotifierHash() => r'4f8c8b4458cb9d3dc915199e62d81062ed549431';

abstract class _$ThemeNotifier extends $Notifier<AppThemeType> {
  AppThemeType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppThemeType, AppThemeType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppThemeType, AppThemeType>,
              AppThemeType,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

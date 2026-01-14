// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kdf_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// KDFService
///
/// Odpowiedzialność:
/// - wyprowadzanie klucza AES z PIN-u użytkownika
/// - generowanie i obsługa SALT
///
/// NIE:
/// - nie przechowuje danych
/// - nie zna deviceId
/// - nie hashuje PIN-u (to robi HashService)

@ProviderFor(kdfService)
final kdfServiceProvider = KdfServiceProvider._();

/// KDFService
///
/// Odpowiedzialność:
/// - wyprowadzanie klucza AES z PIN-u użytkownika
/// - generowanie i obsługa SALT
///
/// NIE:
/// - nie przechowuje danych
/// - nie zna deviceId
/// - nie hashuje PIN-u (to robi HashService)

final class KdfServiceProvider
    extends $FunctionalProvider<KdfService, KdfService, KdfService>
    with $Provider<KdfService> {
  /// KDFService
  ///
  /// Odpowiedzialność:
  /// - wyprowadzanie klucza AES z PIN-u użytkownika
  /// - generowanie i obsługa SALT
  ///
  /// NIE:
  /// - nie przechowuje danych
  /// - nie zna deviceId
  /// - nie hashuje PIN-u (to robi HashService)
  KdfServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kdfServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kdfServiceHash();

  @$internal
  @override
  $ProviderElement<KdfService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  KdfService create(Ref ref) {
    return kdfService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KdfService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KdfService>(value),
    );
  }
}

String _$kdfServiceHash() => r'09918c7ef93d760f94ce395c71b46657af3e5295';

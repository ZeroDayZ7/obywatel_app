// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'63c4d6e8ab059d587fc48306c31d85c057cae52e';

@ProviderFor(notificationsDao)
final notificationsDaoProvider = NotificationsDaoProvider._();

final class NotificationsDaoProvider
    extends
        $FunctionalProvider<
          NotificationsDao,
          NotificationsDao,
          NotificationsDao
        >
    with $Provider<NotificationsDao> {
  NotificationsDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsDaoHash();

  @$internal
  @override
  $ProviderElement<NotificationsDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotificationsDao create(Ref ref) {
    return notificationsDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationsDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationsDao>(value),
    );
  }
}

String _$notificationsDaoHash() => r'7d02f47c58aa54a481893e5fac13c2a1ac159d68';

@ProviderFor(cryptoKeysDao)
final cryptoKeysDaoProvider = CryptoKeysDaoProvider._();

final class CryptoKeysDaoProvider
    extends $FunctionalProvider<CryptoKeysDao, CryptoKeysDao, CryptoKeysDao>
    with $Provider<CryptoKeysDao> {
  CryptoKeysDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cryptoKeysDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cryptoKeysDaoHash();

  @$internal
  @override
  $ProviderElement<CryptoKeysDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CryptoKeysDao create(Ref ref) {
    return cryptoKeysDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CryptoKeysDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CryptoKeysDao>(value),
    );
  }
}

String _$cryptoKeysDaoHash() => r'48e307f0f865db35936247ce437acb77b3f22c2c';

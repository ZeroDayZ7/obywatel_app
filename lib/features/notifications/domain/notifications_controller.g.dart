// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationsController)
final notificationsControllerProvider = NotificationsControllerProvider._();

final class NotificationsControllerProvider
    extends
        $StreamNotifierProvider<
          NotificationsController,
          List<NotificationModel>
        > {
  NotificationsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsControllerHash();

  @$internal
  @override
  NotificationsController create() => NotificationsController();
}

String _$notificationsControllerHash() =>
    r'4937b8853073a81f8a267306c05f7adf4879259f';

abstract class _$NotificationsController
    extends $StreamNotifier<List<NotificationModel>> {
  Stream<List<NotificationModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<NotificationModel>>,
              List<NotificationModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<NotificationModel>>,
                List<NotificationModel>
              >,
              AsyncValue<List<NotificationModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(trashNotifications)
final trashNotificationsProvider = TrashNotificationsProvider._();

final class TrashNotificationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NotificationModel>>,
          List<NotificationModel>,
          Stream<List<NotificationModel>>
        >
    with
        $FutureModifier<List<NotificationModel>>,
        $StreamProvider<List<NotificationModel>> {
  TrashNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trashNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trashNotificationsHash();

  @$internal
  @override
  $StreamProviderElement<List<NotificationModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<NotificationModel>> create(Ref ref) {
    return trashNotifications(ref);
  }
}

String _$trashNotificationsHash() =>
    r'24752c28df1e7a077c574bb1470ac1f4e7d4fe49';

@ProviderFor(NotificationsBackgroundSync)
final notificationsBackgroundSyncProvider =
    NotificationsBackgroundSyncProvider._();

final class NotificationsBackgroundSyncProvider
    extends $NotifierProvider<NotificationsBackgroundSync, void> {
  NotificationsBackgroundSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsBackgroundSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsBackgroundSyncHash();

  @$internal
  @override
  NotificationsBackgroundSync create() => NotificationsBackgroundSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$notificationsBackgroundSyncHash() =>
    r'afa9fb2ed3bebcd2110cbc6c0cac9a42f9ba8a8e';

abstract class _$NotificationsBackgroundSync extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(unreadNotificationsCount)
final unreadNotificationsCountProvider = UnreadNotificationsCountProvider._();

final class UnreadNotificationsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  UnreadNotificationsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadNotificationsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadNotificationsCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return unreadNotificationsCount(ref);
  }
}

String _$unreadNotificationsCountHash() =>
    r'd6fc2d687572d1acbaa244d2619ebca580765788';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatSyncStatusController)
final chatSyncStatusControllerProvider = ChatSyncStatusControllerProvider._();

final class ChatSyncStatusControllerProvider
    extends $NotifierProvider<ChatSyncStatusController, SyncStatus> {
  ChatSyncStatusControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSyncStatusControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSyncStatusControllerHash();

  @$internal
  @override
  ChatSyncStatusController create() => ChatSyncStatusController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncStatus>(value),
    );
  }
}

String _$chatSyncStatusControllerHash() =>
    r'b8a1640474f67a43479e12900f6fdeff4315bc25';

abstract class _$ChatSyncStatusController extends $Notifier<SyncStatus> {
  SyncStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncStatus, SyncStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncStatus, SyncStatus>,
              SyncStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(chatSyncService)
final chatSyncServiceProvider = ChatSyncServiceProvider._();

final class ChatSyncServiceProvider
    extends
        $FunctionalProvider<ChatSyncService, ChatSyncService, ChatSyncService>
    with $Provider<ChatSyncService> {
  ChatSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSyncServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSyncServiceHash();

  @$internal
  @override
  $ProviderElement<ChatSyncService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatSyncService create(Ref ref) {
    return chatSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatSyncService>(value),
    );
  }
}

String _$chatSyncServiceHash() => r'7ab6cfe684637c152caa92b1820797bee632aa11';

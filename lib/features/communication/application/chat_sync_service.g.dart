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
    r'7fc041488a37f47fdb4c7f6ebdeb23ccbc5a992f';

abstract class _$ChatSyncStatusController extends $Notifier<SyncStatus> {
  SyncStatus build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncStatus, SyncStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncStatus, SyncStatus>,
              SyncStatus,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
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
        isAutoDispose: false,
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

String _$chatSyncServiceHash() => r'e1084c6d86d8bd3b6bc6a72a570e63d70b7d17df';

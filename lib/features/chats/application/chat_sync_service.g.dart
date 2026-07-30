// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$chatSyncServiceHash() => r'2b694d9c0252adce8c9ca741df5b2c166a7f3657';

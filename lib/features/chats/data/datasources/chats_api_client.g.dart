// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatsApiClient)
final chatsApiClientProvider = ChatsApiClientProvider._();

final class ChatsApiClientProvider
    extends $FunctionalProvider<ChatsApiClient, ChatsApiClient, ChatsApiClient>
    with $Provider<ChatsApiClient> {
  ChatsApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatsApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatsApiClientHash();

  @$internal
  @override
  $ProviderElement<ChatsApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatsApiClient create(Ref ref) {
    return chatsApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatsApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatsApiClient>(value),
    );
  }
}

String _$chatsApiClientHash() => r'5024813539253f5f75e65a0fe9b1334ddff35ac3';

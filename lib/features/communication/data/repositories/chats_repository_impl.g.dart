// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatsRepository)
final chatsRepositoryProvider = ChatsRepositoryProvider._();

final class ChatsRepositoryProvider
    extends
        $FunctionalProvider<ChatsRepository, ChatsRepository, ChatsRepository>
    with $Provider<ChatsRepository> {
  ChatsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatsRepository create(Ref ref) {
    return chatsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatsRepository>(value),
    );
  }
}

String _$chatsRepositoryHash() => r'5a8c34c4914cd1245d71c653709a02d3a0d6ed61';

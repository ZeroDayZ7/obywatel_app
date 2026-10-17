// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communication_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatWebSocketSession)
final chatWebSocketSessionProvider = ChatWebSocketSessionProvider._();

final class ChatWebSocketSessionProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  ChatWebSocketSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatWebSocketSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatWebSocketSessionHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return chatWebSocketSession(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$chatWebSocketSessionHash() =>
    r'0ed4325388f947c37d8fc756619a1bc43f05f05a';

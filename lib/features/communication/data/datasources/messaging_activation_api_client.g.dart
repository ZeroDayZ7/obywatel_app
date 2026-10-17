// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_activation_api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(messagingActivationApiClient)
final messagingActivationApiClientProvider =
    MessagingActivationApiClientProvider._();

final class MessagingActivationApiClientProvider
    extends
        $FunctionalProvider<
          MessagingActivationApiClient,
          MessagingActivationApiClient,
          MessagingActivationApiClient
        >
    with $Provider<MessagingActivationApiClient> {
  MessagingActivationApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messagingActivationApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messagingActivationApiClientHash();

  @$internal
  @override
  $ProviderElement<MessagingActivationApiClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MessagingActivationApiClient create(Ref ref) {
    return messagingActivationApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessagingActivationApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessagingActivationApiClient>(value),
    );
  }
}

String _$messagingActivationApiClientHash() =>
    r'6214d42418fc2d1b5b8ecc0bd84596809b82e5b8';

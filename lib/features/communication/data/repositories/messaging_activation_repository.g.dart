// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_activation_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(messagingActivationRepository)
final messagingActivationRepositoryProvider =
    MessagingActivationRepositoryProvider._();

final class MessagingActivationRepositoryProvider
    extends
        $FunctionalProvider<
          MessagingActivationRepository,
          MessagingActivationRepository,
          MessagingActivationRepository
        >
    with $Provider<MessagingActivationRepository> {
  MessagingActivationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messagingActivationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messagingActivationRepositoryHash();

  @$internal
  @override
  $ProviderElement<MessagingActivationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MessagingActivationRepository create(Ref ref) {
    return messagingActivationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessagingActivationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessagingActivationRepository>(
        value,
      ),
    );
  }
}

String _$messagingActivationRepositoryHash() =>
    r'2fbe2b31a27f68ad31239a3f9155557ad42a0d99';

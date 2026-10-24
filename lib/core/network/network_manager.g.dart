// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(networkManager)
final networkManagerProvider = NetworkManagerProvider._();

final class NetworkManagerProvider
    extends $FunctionalProvider<NetworkManager, NetworkManager, NetworkManager>
    with $Provider<NetworkManager> {
  NetworkManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkManagerHash();

  @$internal
  @override
  $ProviderElement<NetworkManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NetworkManager create(Ref ref) {
    return networkManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkManager>(value),
    );
  }
}

String _$networkManagerHash() => r'99b354db4fc52de8bad812e592c8b487c0da4f10';

@ProviderFor(networkState)
final networkStateProvider = NetworkStateProvider._();

final class NetworkStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<NetworkState>,
          NetworkState,
          Stream<NetworkState>
        >
    with $FutureModifier<NetworkState>, $StreamProvider<NetworkState> {
  NetworkStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkStateHash();

  @$internal
  @override
  $StreamProviderElement<NetworkState> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<NetworkState> create(Ref ref) {
    return networkState(ref);
  }
}

String _$networkStateHash() => r'cc45e6906f699642b216b3efba2ff5b1d468aba6';

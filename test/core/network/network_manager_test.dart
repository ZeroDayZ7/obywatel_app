import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/network/network_manager.dart';

void main() {
  group('NetworkManager', () {
    test('marks backend unavailable and blocks requests during cooldown', () {
      final manager = NetworkManager(
        connectivity: ConnectivityAdapter(Connectivity()),
        clock: () => DateTime(2024, 1, 1, 12, 0, 0),
      );

      manager.markBackendUnavailable(cooldown: const Duration(seconds: 30));

      expect(manager.state, NetworkState.backendUnavailable);
      expect(manager.shouldFailFast(), isTrue);
    });

    test('clears backend downtime when connectivity recovers', () {
      final manager = NetworkManager(
        connectivity: ConnectivityAdapter(Connectivity()),
        clock: () => DateTime(2024, 1, 1, 12, 0, 0),
      );

      manager.markBackendUnavailable(cooldown: const Duration(seconds: 30));
      manager.resetAfterConnectivityRecovery();

      expect(manager.state, NetworkState.online);
      expect(manager.shouldFailFast(), isFalse);
    });

    test('offline is distinct from backend unavailable', () {
      final manager = NetworkManager(
        connectivity: ConnectivityAdapter(Connectivity()),
        clock: () => DateTime(2024, 1, 1, 12, 0, 0),
      );

      manager.markOffline();

      expect(manager.state, NetworkState.offline);
      expect(manager.shouldFailFast(), isTrue);
      expect(manager.isBackendUnavailable, isFalse);
    });

    test('all consumers share the same global manager instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final managerA = container.read(networkManagerProvider);
      final managerB = container.read(networkManagerProvider);

      expect(identical(managerA, managerB), isTrue);
      expect(managerA.state, NetworkState.online);
    });
  });
}

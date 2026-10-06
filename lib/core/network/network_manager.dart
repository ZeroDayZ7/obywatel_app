import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NetworkState {
  online,
  offline,
  retrying,
  backendUnavailable,
}

abstract interface class ConnectivityFacade {
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
  Future<List<ConnectivityResult>> checkConnectivity();
}

class ConnectivityAdapter implements ConnectivityFacade {
  const ConnectivityAdapter(this._connectivity);

  final Connectivity _connectivity;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() =>
      _connectivity.checkConnectivity();
}

class NetworkManager {
  NetworkManager({
    ConnectivityFacade? connectivity,
    DateTime Function()? clock,
  })  : _connectivity = connectivity ?? ConnectivityAdapter(Connectivity()),
        _clock = clock ?? DateTime.now;

  final ConnectivityFacade _connectivity;
  final DateTime Function() _clock;
  final StreamController<NetworkState> _stateController =
      StreamController<NetworkState>.broadcast();

  DateTime? _backendUnavailableUntil;
  NetworkState _state = NetworkState.online;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<NetworkState> get stream => _stateController.stream;
  NetworkState get state => _state;

  bool get isOffline => _state == NetworkState.offline;

  bool get isBackendUnavailable =>
      _state == NetworkState.backendUnavailable ||
      (_backendUnavailableUntil != null &&
          _backendUnavailableUntil!.isAfter(_clock()));

  Future<void> start() async {
    _subscription ??= _connectivity.onConnectivityChanged.listen((results) {
      _applyConnectivity(results);
    });

    final results = await _connectivity.checkConnectivity();
    _applyConnectivity(results);
  }

  void dispose() {
    _subscription?.cancel();
    _stateController.close();
  }

  void _emitState() {
    if (!_stateController.isClosed) {
      _stateController.add(_state);
    }
  }

  void _applyConnectivity(List<ConnectivityResult> results) {
    final isOffline = results.contains(ConnectivityResult.none);

    if (isOffline) {
      markOffline();
      return;
    }

    if (_backendUnavailableUntil != null &&
        _backendUnavailableUntil!.isAfter(_clock())) {
      _state = NetworkState.backendUnavailable;
      _emitState();
      return;
    }

    markOnline();
  }

  bool shouldFailFast() {
    final now = _clock();

    if (_state == NetworkState.offline) {
      return true;
    }

    if (_backendUnavailableUntil != null &&
        _backendUnavailableUntil!.isAfter(now)) {
      _state = NetworkState.backendUnavailable;
      _emitState();
      return true;
    }

    if (_backendUnavailableUntil != null &&
        !_backendUnavailableUntil!.isAfter(now)) {
      _backendUnavailableUntil = null;
      _state = NetworkState.online;
      _emitState();
    }

    return false;
  }

  void markOffline() {
    _backendUnavailableUntil = null;
    _state = NetworkState.offline;
    _emitState();
  }

  void markOnline() {
    _backendUnavailableUntil = null;
    _state = NetworkState.online;
    _emitState();
  }

  void markRetrying() {
    _state = NetworkState.retrying;
    _emitState();
  }

  void markBackendUnavailable({Duration cooldown = const Duration(seconds: 30)}) {
    _backendUnavailableUntil = _clock().add(cooldown);
    _state = NetworkState.backendUnavailable;
    _emitState();
  }

  void resetAfterConnectivityRecovery() {
    _backendUnavailableUntil = null;
    _state = NetworkState.online;
    _emitState();
  }
}

final networkManagerProvider = Provider<NetworkManager>((ref) {
  final manager = NetworkManager();

  Future.microtask(() {
    try {
      WidgetsBinding.instance;
    } catch (_) {
      return;
    }

    unawaited(manager.start());
  });

  ref.onDispose(manager.dispose);

  return manager;
});

final networkStateProvider = StreamProvider<NetworkState>((ref) {
  final manager = ref.watch(networkManagerProvider);
  return manager.stream;
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/version_providers.dart';

import 'version_state.dart';

final versionNotifierProvider = NotifierProvider<VersionNotifier, VersionState>(
  VersionNotifier.new,
);

class VersionNotifier extends Notifier<VersionState> {
  @override
  VersionState build() {
    _load();
    return const VersionState(
      minVersion: '0.0.0',
      latestVersion: '0.0.0',
      forceUpdate: false,
    );
  }

  Future<void> _load() async {
    final service = ref.read(versionServiceProvider);
    final stateFromApi = await service.fetchVersionState();
    final current = await service.currentVersion();

    final mustUpdate = service.isBelowMinimum(current, stateFromApi.minVersion);

    state = stateFromApi.copyWith(forceUpdate: mustUpdate);
  }
}

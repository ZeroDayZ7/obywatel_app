import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../security/security_service_provider.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  final Ref ref;

  AppLifecycleObserver(this.ref);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final security = ref.read(securityServiceProvider.notifier);

    switch (state) {
      case AppLifecycleState.resumed:
        security.onAppResumed();
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        security.onAppHidden();
        break;

      default:
        break;
    }
  }
}
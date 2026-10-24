import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/security/pin/change_pin_notifier.dart';
import 'package:obywatel_plus/core/security/pin/change_pin_state.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/features/settings/presentation/pages/change_pin_screen.dart';

class _FakeSecurityService extends SecurityService {
  _FakeSecurityService(this.method);

  final LocalSecurityMethod method;

  @override
  SecurityState build() {
    return SecurityState.initial().copyWith(
      initialized: true,
      isSetupCompleted: true,
      localSecurityMethod: method,
      hasLocalLock: false,
    );
  }
}

class _RecordingChangePinNotifier extends ChangePinNotifier {
  int verifyCalls = 0;
  bool initializeCalled = false;

  @override
  ChangePinState build() => const ChangePinState(
    step: ChangePinStep.enterOld,
    currentMethod: LocalSecurityMethod.password,
    targetMethod: LocalSecurityMethod.password,
    operationType: ChangePinOperationType.changeSecret,
  );

  @override
  void initialize({
    required LocalSecurityMethod currentMethod,
    ChangePinOperationType operationType = ChangePinOperationType.changeSecret,
    LocalSecurityMethod? targetMethod,
  }) {
    initializeCalled = true;
    super.initialize(
      currentMethod: currentMethod,
      operationType: operationType,
      targetMethod: targetMethod,
    );
  }

  @override
  Future<void> verifyCurrentSecretAndSave(
    List<int> secret, {
    required LocalSecurityMethod currentMethod,
  }) async {
    verifyCalls += 1;
    state = const ChangePinState(
      step: ChangePinStep.enterNew,
      currentMethod: LocalSecurityMethod.password,
      targetMethod: LocalSecurityMethod.password,
      operationType: ChangePinOperationType.changeSecret,
    );
  }
}

class _AlignedErrorPinNotifier extends ChangePinNotifier {
  bool initializeCalled = false;

  @override
  ChangePinState build() => const ChangePinState(
    step: ChangePinStep.error,
    currentMethod: LocalSecurityMethod.pin,
    targetMethod: LocalSecurityMethod.pin,
    operationType: ChangePinOperationType.changeSecret,
    errorMessageKey: 'pin_dialog.invalid_pin',
  );

  @override
  void initialize({
    required LocalSecurityMethod currentMethod,
    ChangePinOperationType operationType = ChangePinOperationType.changeSecret,
    LocalSecurityMethod? targetMethod,
  }) {
    initializeCalled = true;
    super.initialize(
      currentMethod: currentMethod,
      operationType: operationType,
      targetMethod: targetMethod,
    );
  }
}

Widget _buildScreen({
  required LocalSecurityMethod method,
  required ChangePinNotifier notifier,
  String? route,
}) {
  final router = GoRouter(
    initialLocation: route ?? '/?method=${method.name}',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ChangePinScreen(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      securityServiceProvider.overrideWith(() => _FakeSecurityService(method)),
      changePinProvider.overrideWith(() => notifier),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  group('ChangePinScreen regression', () {
    testWidgets('password 9 chars can be entered fully without auto-submit', (
      tester,
    ) async {
      final notifier = _RecordingChangePinNotifier();

      await tester.pumpWidget(
        _buildScreen(
          method: LocalSecurityMethod.password,
          notifier: notifier,
          route: '/?method=password',
        ),
      );

      final field = find.byType(TextFormField).first;
      await tester.enterText(field, 'Abc12345');
      await tester.pump();

      expect(notifier.verifyCalls, 0);
      expect(notifier.state.step, ChangePinStep.enterOld);
      expect(find.text('Dalej'), findsOneWidget);
    });

    testWidgets('route mismatch does not silently fall back to PIN mode', (
      tester,
    ) async {
      final notifier = _RecordingChangePinNotifier();

      await tester.pumpWidget(
        _buildScreen(
          method: LocalSecurityMethod.password,
          notifier: notifier,
          route: '/?method=pin',
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Podaj aktualny PIN — 4 znaki'), findsNothing);
    });

    testWidgets('pin mode keeps the explicit current-secret step until submit', (tester) async {
      final notifier = _RecordingChangePinNotifier();

      await tester.pumpWidget(
        _buildScreen(
          method: LocalSecurityMethod.pin,
          notifier: notifier,
          route: '/?method=pin',
        ),
      );

      final field = find.byType(TextFormField).first;
      await tester.enterText(field, '1234');
      await tester.pump();

      expect(notifier.verifyCalls, 0);
      expect(notifier.state.step, ChangePinStep.enterOld);
    });

    testWidgets('button is disabled while loading', (tester) async {
      final notifier = _RecordingChangePinNotifier();

      await tester.pumpWidget(
        _buildScreen(
          method: LocalSecurityMethod.password,
          notifier: notifier,
          route: '/?method=password',
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);

      notifier.state = const ChangePinState(
        step: ChangePinStep.loading,
        currentMethod: LocalSecurityMethod.password,
        targetMethod: LocalSecurityMethod.password,
        operationType: ChangePinOperationType.changeSecret,
      );
      await tester.pump();

      final loadingButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(loadingButton.onPressed, isNull);
    });

    testWidgets('missing route method does not reset an active error flow', (tester) async {
      final notifier = _AlignedErrorPinNotifier();

      await tester.pumpWidget(
        _buildScreen(
          method: LocalSecurityMethod.pin,
          notifier: notifier,
          route: '/?mode=change_secret',
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(notifier.initializeCalled, isFalse);
    });
  });
}

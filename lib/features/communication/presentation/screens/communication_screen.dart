import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:obywatel_plus/features/communication/application/messaging_activation_controller.dart';
import 'package:obywatel_plus/features/communication/application/websocket_message_handler.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_ws_client.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/communication/communication_tab_view.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/communication/messaging_activation_error.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messaging_onboarding_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'communication_screen.g.dart';

@riverpod
void chatWebSocketSession(Ref ref) {
  String? lastAccessToken;

  Future<void> sync(AuthState authState) async {
    final wsClient = ref.read(chatsWsClientProvider);
    final token = await ref.read(authFreshProvider).token;
    final accessToken = token?.accessToken ?? '';

    if (authState.isAuthenticated && accessToken.isNotEmpty) {
      if (lastAccessToken == accessToken) {
        return;
      }

      lastAccessToken = accessToken;
      await wsClient.connectWithToken(accessToken);
      return;
    }

    if (lastAccessToken != null || wsClient.isConnected) {
      lastAccessToken = null;
      await wsClient.disconnect();
    }
  }

  ref.listen<AuthState>(authControllerProvider, (_, next) {
    unawaited(sync(next));
  });

  unawaited(sync(ref.read(authControllerProvider)));

  ref.onDispose(() {
    lastAccessToken = null;
  });
}

class CommunicationScreen extends ConsumerStatefulWidget {
  const CommunicationScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<CommunicationScreen> createState() =>
      _CommunicationScreenState();
}

class _CommunicationScreenState extends ConsumerState<CommunicationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messagingActivationControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(chatWebSocketSessionProvider);
    ref.watch(webSocketMessageHandlerProvider);

    final state = ref.watch(messagingActivationControllerProvider);
    final activationState = state.value ?? const MessagingActivationState();

    if (state.isLoading &&
        activationState.status == null &&
        activationState.terms == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.hasError &&
        activationState.status == null &&
        activationState.terms == null) {
      return MessagingActivationError(
        errorMessage: activationState.errorMessage,
      );
    }

    if (activationState.shouldShowOnboarding) {
      return const MessagingOnboardingScreen();
    }

    return CommunicationTabView(initialIndex: widget.initialIndex);
  }
}

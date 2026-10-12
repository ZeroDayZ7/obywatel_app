import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:obywatel_plus/features/communication/application/messaging_activation_controller.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_ws_client.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/contacts_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/conversations_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messaging_onboarding_screen.dart';

final chatWebSocketSessionProvider = Provider<void>((ref) {
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

  return;
});

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
    final wsStatusValue = ref.watch(chatsWsStatusProvider);
    final wsStatus = kDebugMode
        ? switch (wsStatusValue) {
            AsyncData(:final value) => value,
            _ => null,
          }
        : null;
    final state = ref.watch(messagingActivationControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.hasError) {
      final error = state.error;
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 48,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nie udało się pobrać stanu komunikatora.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(error.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => ref
                      .read(messagingActivationControllerProvider.notifier)
                      .load(),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final activationState = state.value ?? const MessagingActivationState();
    if (activationState.shouldShowOnboarding) {
      return const MessagingOnboardingScreen();
    }

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Komunikacja'),
          centerTitle: false,
          surfaceTintColor: Colors.transparent,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TabBar(
                  isScrollable: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                  tabAlignment: TabAlignment.start,
                  tabs: const [
                    Tab(text: 'Wiadomości'),
                    Tab(text: 'Kontakty'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (kDebugMode && wsStatus != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.2,
                        ),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: switch (wsStatus) {
                            WsConnectionStatus.connected => Colors.green,
                            WsConnectionStatus.connecting => Colors.orange,
                            WsConnectionStatus.disconnected => Colors.red,
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(switch (wsStatus) {
                        WsConnectionStatus.connected => 'Connected',
                        WsConnectionStatus.connecting => 'Connecting',
                        WsConnectionStatus.disconnected => 'Disconnected',
                      }, style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                ),
              const Expanded(
                child: TabBarView(
                  children: [ConversationsScreen(), ContactsScreen()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

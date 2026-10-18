import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_ws_client.dart';

class WebSocketStatusBar extends ConsumerWidget {
  const WebSocketStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    final wsStatusValue = ref.watch(chatsWsStatusProvider);
    final wsStatus = switch (wsStatusValue) {
      AsyncData(:final value) => value,
      _ => null,
    };

    if (wsStatus == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
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
    );
  }
}

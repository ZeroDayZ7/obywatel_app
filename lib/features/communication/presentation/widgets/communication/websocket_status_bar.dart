import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';

class WebSocketStatusBar extends ConsumerWidget {
  const WebSocketStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Always visible in the communication app bar; keep the compact status dot
    // independent from the responsive navigation layout and its conditional UI.
    final wsStatusValue = ref.watch(appWebSocketStatusProvider);
    final wsStatus = switch (wsStatusValue) {
      AsyncData(:final value) => value,
      _ => WsConnectionStatus.disconnected,
    };

    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: switch (wsStatus) {
          WsConnectionStatus.connected => Colors.green,
          WsConnectionStatus.connecting => Colors.orange,
          WsConnectionStatus.disconnected => Colors.red,
        },
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

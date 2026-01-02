import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/widgets/responsive_content_wrapper.dart';
import 'package:obywatel_plus/features/settings/application/active_sessions_provider.dart';
import 'package:obywatel_plus/features/settings/application/user_session.dart';

class ActiveSessionsScreen extends ConsumerWidget {
  const ActiveSessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(activeSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_security_active_sessions.tr()),
        centerTitle: true,
      ),
      body: ResponsiveContainer(
        useTopAlignment: true,
        child: sessionsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                const SizedBox(height: 16),
                Text(LocaleKeys.errors_general.tr()),
                TextButton(
                  onPressed: () => ref.invalidate(activeSessionsProvider),
                  child: const Text("Retry"),
                ),
              ],
            ),
          ),
          data: (sessions) => RefreshIndicator(
            onRefresh: () => ref.refresh(activeSessionsProvider.future),
            child: sessions.isEmpty
                ? const Center(child: Text("No active sessions found"))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: sessions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _SessionTile(session: sessions[index]);
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class _SessionTile extends ConsumerWidget {
  final UserSession session;

  const _SessionTile({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Formatowanie daty (wymaga importu intl lub użycia metody z easy_localization)
    final String formattedDate = DateFormat(
      'dd.MM.yyyy HH:mm',
    ).format(session.createdAt);

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(
          session.isCurrent ? Icons.phonelink_setup : Icons.devices,
          color: session.isCurrent ? Colors.green : Colors.blueGrey,
        ),
        title: Text(
          session.deviceName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Platform: ${session.platform}\n"
          "Last activity: $formattedDate",
          style: const TextStyle(fontSize: 12),
        ),
        isThreeLine: true,
        trailing: session.isCurrent
            ? const Badge(label: Text("Current"))
            : IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                onPressed: () {
                  _confirmTermination(context, ref);
                },
              ),
      ),
    );
  }

  void _confirmTermination(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Terminate Session?"),
        content: const Text("This device will be logged out."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(activeSessionsProvider.notifier)
                  .terminateSession(session.id);
              Navigator.pop(context);
            },
            child: const Text("Terminate", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

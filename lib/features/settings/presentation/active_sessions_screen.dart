import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/features/settings/application/active_sessions_provider.dart';
import 'package:obywatel_plus/features/settings/application/user_session.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/settings_card.dart';

class ActiveSessionsScreen extends ConsumerWidget {
  const ActiveSessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(activeSessionsProvider);

    return AppScaffold(
      title: Text(LocaleKeys.settings_security_active_sessions.tr()),
      size: ContainerSize.medium,
      scrollable: false,
      padding: EdgeInsets.zero,
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
              ? ListView(
                  children: const [
                    SizedBox(height: 100),
                    Center(child: Text("No active sessions found")),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  itemCount: sessions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _SessionTile(session: sessions[index]);
                  },
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
    final String formattedDate = DateFormat(
      'dd.MM.yyyy HH:mm',
    ).format(session.createdAt);

    return SettingsCard(
      icon: session.isCurrent ? Icons.phonelink_setup : Icons.devices,
      title: session.deviceName,
      subtitle: "Platform: ${session.platform}\nLast activity: $formattedDate",
      onTap: () {},
      trailing: session.isCurrent
          ? Badge(
              label: const Text("Current"),
              backgroundColor: Colors.green.withValues(alpha: 0.1),
              textColor: Colors.green,
            )
          : IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              onPressed: () => _confirmTermination(context, ref),
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

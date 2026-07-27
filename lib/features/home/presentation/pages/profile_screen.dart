import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/core/utils/date_formatter.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final user = authState.maybeMap(
      authenticated: (state) => state.user,
      orElse: () => null,
    );

    if (user == null) {
      return const AppScaffold(
        size: ContainerSize.medium,
        appBar: AppAppBar(title: 'Profil', showBackButton: false),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final formattedStatus = _formatStatus(user.status);
    final formattedLastLogin = user.lastLogin != null
        ? DateFormatter.formatRelativeDateTime(user.lastLogin!)
        : null;

    final statusColor = user.status.toLowerCase() == 'active'
        ? colorScheme.primary
        : colorScheme.secondary;

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: const AppAppBar(title: 'Profil', showBackButton: false),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 44,
                  backgroundImage: AssetImage(
                    'assets/images/avatar_placeholder.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 22,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${user.id}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            formattedStatus,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _ProfileCard(
              icon: Icons.email_outlined,
              title: 'Adres e-mail',
              value: user.email,
            ),
            if (formattedLastLogin != null)
              _ProfileCard(
                icon: Icons.access_time_rounded,
                title: 'Ostatnie logowanie',
                value: formattedLastLogin,
              ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  icon: Icons.qr_code_rounded,
                  label: 'Pokaż QR',
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.verified_user_outlined,
                  label: 'Weryfikacja',
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.settings_outlined,
                  label: 'Ustawienia',
                  onTap: () => context.push(AppRoutes.settings),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Konto aktywne';
      case 'pending':
        return 'Oczekuje na weryfikację';
      case 'suspended':
        return 'Konto zawieszone';
      default:
        return status;
    }
  }
}

class _ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      color: colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: colorScheme.primary),
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 12,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        subtitle: Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

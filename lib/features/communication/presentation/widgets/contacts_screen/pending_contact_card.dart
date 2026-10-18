import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';
import 'package:obywatel_plus/features/communication/application/contact_invite_error_mapper.dart';
import 'package:obywatel_plus/features/communication/data/repositories/contacts_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact.dart';

class PendingContactCard extends ConsumerStatefulWidget {
  const PendingContactCard({super.key, required this.contact});

  final Contact contact;

  @override
  ConsumerState<PendingContactCard> createState() => _PendingContactCardState();
}

class _PendingContactCardState extends ConsumerState<PendingContactCard> {
  bool _isProcessing = false;

  Future<void> _handleResponse(bool accept) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final repository = ref.read(contactsRepositoryProvider);
      await repository.respondToRequest(widget.contact.id, accept);

      if (!mounted) return;

      final statusColors = context.statusColors;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            accept
                ? 'Zaproszenie zaakceptowane dla ${widget.contact.displayName}'
                : 'Zaproszenie odrzucone dla ${widget.contact.displayName}',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: accept ? statusColors.success : statusColors.warning,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mapContactInviteError(error)),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isIncoming = widget.contact.direction == 'incoming';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.contact.displayName.isNotEmpty
                  ? widget.contact.displayName[0].toUpperCase()
                  : '?',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact.localAlias?.trim().isNotEmpty == true
                      ? widget.contact.localAlias!
                      : widget.contact.displayName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isIncoming ? 'Zaproszenie oczekujące' : 'Wysłano zaproszenie',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isIncoming)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _isProcessing ? null : () => _handleResponse(true),
                  tooltip: 'Akceptuj',
                  color: colorScheme.primary,
                  icon: const Icon(Icons.check_rounded),
                ),
                IconButton(
                  onPressed: _isProcessing
                      ? null
                      : () => _handleResponse(false),
                  tooltip: 'Odrzuć',
                  color: colorScheme.error,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Wysłano',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

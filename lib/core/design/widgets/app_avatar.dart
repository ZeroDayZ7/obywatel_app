import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/chat_screen/chat_colors.dart';

class AppAvatar extends StatelessWidget {
  final String? username;
  final String? imageUrl;
  final bool isOnline;
  final double size;

  const AppAvatar({
    super.key,
    this.username,
    this.imageUrl,
    this.isOnline = false,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: ClipOval(child: _buildAvatarContent(theme)),
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: const Color(0xFF00FF88),
                shape: BoxShape.circle,
                border: Border.all(color: CyberpunkColors.background, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF88).withValues(alpha: 0.4),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarContent(ThemeData theme) {
    if (imageUrl != null) {
      return Image.network(imageUrl!, fit: BoxFit.cover);
    }
    if (username != null && username!.isNotEmpty) {
      return Center(
        child: Text(
          username![0].toUpperCase(),
          style: TextStyle(
            fontSize: size * 0.45,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }
    return Icon(
      Icons.person,
      color: theme.colorScheme.primary,
      size: size * 0.6,
    );
  }
}

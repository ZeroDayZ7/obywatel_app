import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/env.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF00F0FF), Color(0xFFFF00F5)],
        ).createShader(bounds),
        child: Text(
          apiConstants.appName,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0A0A0F),
      iconTheme: const IconThemeData(color: Color(0xFF00F0FF)),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF1F1F2E), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF00F0FF), size: 22),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

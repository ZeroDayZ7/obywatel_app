import 'package:flutter/material.dart';

class ContactsFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color accentColor;

  const ContactsFAB({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: backgroundColor,
      shape: CircleBorder(side: BorderSide(color: accentColor, width: 2)),
      onPressed: onPressed,
      child: Icon(Icons.person_add_alt_1, color: accentColor),
    );
  }
}

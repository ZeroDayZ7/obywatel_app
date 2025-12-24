// lib/core/widgets/ui/error_message.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        message.tr(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

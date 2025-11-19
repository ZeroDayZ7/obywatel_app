import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDivider extends StatelessWidget {
  final DateTime date;
  const DateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        DateFormat('dd MMM yyyy').format(date),
        style: const TextStyle(color: Colors.white38, fontSize: 12),
      ),
    );
  }
}

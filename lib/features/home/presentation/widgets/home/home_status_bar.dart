import 'package:flutter/material.dart';

class HomeStatusBar extends StatelessWidget {
  const HomeStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF00F0FF), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF00FF88),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF00FF88),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            'SYSTEM AKTYWNY',
            style: TextStyle(
              color: Color(0xFF00F0FF),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

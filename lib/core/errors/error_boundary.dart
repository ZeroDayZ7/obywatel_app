// lib/core/errors/error_boundary.dart
import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/errors/error_screen.dart';
import 'package:obywatel_plus/core/errors/app_error_handler.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;

  const ErrorBoundary({super.key, required this.child});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();

    FlutterError.onError = (FlutterErrorDetails details) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _error = details.exception;
          });
        }
      });

      AppErrorHandler.report(details.exception, details.stack);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return ErrorScreen(message: _error.toString());
    }

    return widget.child;
  }
}

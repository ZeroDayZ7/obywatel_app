import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/design/tokens/layout_tokens.dart';
import 'package:obywatel_plus/core/design/tokens/spacing.dart';

import 'package:obywatel_plus/features/auth/presentation/login/login_form.dart';

class ProfessionalLoginWidget extends ConsumerWidget {
  const ProfessionalLoginWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Layout.maxWidth,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.xxxl,
                vertical: Spacing.xxxxl,
              ),
              child: LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/application/messaging_activation_controller.dart';
import 'package:obywatel_plus/features/communication/domain/models/messaging_activation_state.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/communication/communication_tab_view.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/communication/messaging_activation_error.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messaging_onboarding_screen.dart';

class CommunicationScreen extends ConsumerStatefulWidget {
  const CommunicationScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<CommunicationScreen> createState() =>
      _CommunicationScreenState();
}

class _CommunicationScreenState extends ConsumerState<CommunicationScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messagingActivationControllerProvider);
    final activationState = state.value ?? const MessagingActivationState();

    final hasConfirmedActivation = activationState.hasLocalActivation && activationState.isActive;

    if (state.isLoading && !hasConfirmedActivation && activationState.errorMessage == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.hasError && activationState.errorMessage != null) {
      return MessagingActivationError(
        errorMessage: activationState.errorMessage,
      );
    }

    if (activationState.shouldShowOnboarding) {
      return const MessagingOnboardingScreen();
    }

    return CommunicationTabView(initialIndex: widget.initialIndex);
  }
}

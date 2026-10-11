import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/application/messaging_activation_controller.dart';
import 'package:obywatel_plus/features/communication/presentation/pages/contacts_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/pages/conversations_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messaging_onboarding_screen.dart';

class CommunicationScreen extends ConsumerStatefulWidget {
  const CommunicationScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends ConsumerState<CommunicationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messagingActivationControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messagingActivationControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.hasError) {
      final error = state.error;
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off_rounded, size: 48, color: colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  'Nie udało się pobrać stanu komunikatora.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () =>
                      ref.read(messagingActivationControllerProvider.notifier).load(),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final activationState = state.value ?? const MessagingActivationState();
    if (activationState.shouldShowOnboarding) {
      return const MessagingOnboardingScreen();
    }

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Komunikacja'),
          centerTitle: false,
          surfaceTintColor: Colors.transparent,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TabBar(
                  isScrollable: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                  tabAlignment: TabAlignment.start,
                  tabs: const [
                    Tab(text: 'Wiadomości'),
                    Tab(text: 'Kontakty'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              ConversationsScreen(),
              ContactsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/tokens/spacing.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/core/design/widgets/ui/text_field.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_notification_provider.dart';
import 'package:obywatel_plus/core/security/pin/change_pin_notifier.dart';
import 'package:obywatel_plus/core/security/pin/change_pin_state.dart';

class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  final PageController _pageController = PageController();

  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  final _oldPinFocus = FocusNode();
  final _newPinFocus = FocusNode();
  final _confirmPinFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _oldPinFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    _oldPinFocus.dispose();
    _newPinFocus.dispose();
    _confirmPinFocus.dispose();
    super.dispose();
  }

  void _showError(String messageKey) {
    ref
        .read(globalNotificationProvider.notifier)
        .show(
          AppNotification(messageKey: messageKey, type: NotificationType.error),
        );
  }

  void _goTo(int page) {
    if (!_pageController.hasClients) return;

    FocusManager.instance.primaryFocus?.unfocus();

    _pageController
        .animateToPage(
          page,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOutCubic,
        )
        .then((_) {
          if (!mounted) return;

          final List<FocusNode> nodes = [
            _oldPinFocus,
            _newPinFocus,
            _confirmPinFocus,
          ];

          if (page >= 0 && page < nodes.length) {
            nodes[page].requestFocus();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ChangePinState>(changePinProvider, (prev, next) {
      next.maybeWhen(
        enterOld: () => _goTo(0),
        enterNew: () => _goTo(1),
        confirmNew: () => _goTo(2),
        success: () {
          ref
              .read(globalNotificationProvider.notifier)
              .show(
                AppNotification(
                  messageKey: LocaleKeys.pin_dialog_changed_success,
                  type: NotificationType.success,
                ),
              );
          Navigator.pop(context);
        },
        error: (key) => _showError(key),
        orElse: () {},
      );
    });

    final state = ref.watch(changePinProvider);
    final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

    return AppScaffold(
      size: ContainerSize.compact,
      alignment: Alignment.center,
      appBar: AppBar(
        title: Text(LocaleKeys.settings_common_change_pin.tr()),
        centerTitle: true,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 300,
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep(
                  title: LocaleKeys.pin_dialog_enter_old_pin.tr(),
                  controller: _oldPinController,
                  focusNode: _oldPinFocus,
                  isLoading: isLoading,
                  onCompleted: (pin) {
                    ref
                        .read(changePinProvider.notifier)
                        .verifyOldPin(pin.codeUnits.toList());
                    _oldPinController.clear();
                  },
                ),
                _buildStep(
                  title: LocaleKeys.pin_dialog_set_pin_title.tr(),
                  controller: _newPinController,
                  focusNode: _newPinFocus,
                  isLoading: isLoading,
                  onCompleted: (pin) {
                    ref
                        .read(changePinProvider.notifier)
                        .setNewPin(pin.codeUnits.toList());
                    _newPinController.clear();
                  },
                ),
                _buildStep(
                  title: LocaleKeys.pin_dialog_repeat_pin_title.tr(),
                  controller: _confirmPinController,
                  focusNode: _confirmPinFocus,
                  isLoading: isLoading,
                  onCompleted: (pin) {
                    Future.microtask(() async {
                      await ref
                          .read(changePinProvider.notifier)
                          .confirmAndSave(pin.codeUnits.toList());
                      _confirmPinController.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
    required void Function(String) onCompleted,
    bool isLoading = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: Spacing.xl),
            child: CircularProgressIndicator(),
          ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: Spacing.xxl),
        AppTextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: false,
          labelText: LocaleKeys.pin_dialog_enter_4_digits.tr(),
          obscureText: true,
          enabled: !isLoading,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          onChanged: (val) {
            if (val.length == 4 && !isLoading) {
              onCompleted(val);
            }
          },
        ),
      ],
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';

class PinTile extends StatelessWidget {
  final bool pinSet;
  final VoidCallback onSetup;

  const PinTile({required this.pinSet, required this.onSetup, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.lock),
      title: Text(
        pinSet
            ? LocaleKeys.security_setup_pin_set.tr()
            : LocaleKeys.security_setup_set_pin.tr(),
      ),
      trailing: AppButton(
        label: LocaleKeys.security_setup_set.tr(),
        onPressed: pinSet ? null : onSetup,
        variant: AppButtonVariant.text,
        fullWidth: false,
      ),
    );
  }
}

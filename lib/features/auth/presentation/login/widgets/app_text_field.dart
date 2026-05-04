import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelKey;
  final String? hintKey;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final Widget? prefixIcon;
  final String? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const AppTextField({
    super.key,
    this.controller,
    required this.labelKey,
    this.hintKey,
    this.validator,
    this.isPassword = false,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.prefixIcon,
    this.autofillHints,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      obscureText: widget.isPassword ? _obscureText : false,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      autofillHints: widget.autofillHints != null
          ? [widget.autofillHints!]
          : null,
      decoration: InputDecoration(
        labelText: widget.labelKey.tr(),
        hintText: widget.hintKey?.tr(),
        helperText: ' ',
        errorMaxLines: 1,

        labelStyle: TextStyle(
          color: Colors.grey, // normalny stan
        ),
        floatingLabelStyle: TextStyle(
          color: Colors.blue, // focus / wpisywanie
        ),

        // hoverColor: Colors.transparent,
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.grey),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.blue),
        // ),
        // errorBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red),
        // ),

        // focusedErrorBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.redAccent),
        // ),

        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: theme.iconTheme.color?.withValues(alpha: 0.7),
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
      ),
    );
  }
}

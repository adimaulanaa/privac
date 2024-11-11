import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privac/core/uikit/uikit.dart';

class UITextInput extends StatelessWidget {
  const UITextInput({
    super.key,
    this.label,
    this.hint,
    this.helper,
    this.obscureText = false,
    this.onChanged,
    this.controller,
    this.suffix,
    this.minLines,
    this.maxLines = 1,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final String? label;
  final String? hint;
  final String? helper;
  final bool obscureText;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final Widget? suffix;
  final int? minLines;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: context.uiText.title1.medium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffix: suffix,
        helperText: helper,
        helperMaxLines: 2,
      ),
      obscureText: obscureText,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autocorrect: false,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}

import 'package:client/core/theme/app.theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? hintText;
  final List<String? Function(String?)>? validators;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.validators,
  });

  String? _combineValidators(String? value) {
    if (validators == null) return null;
    for (final validator in validators!) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppTheme.bodyTextStyle,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppTheme.bodyTextStyle,
        hintText: hintText,
        hintStyle: AppTheme.bodyTextStyle.copyWith(color: Colors.grey),
        filled: true,
        fillColor: AppTheme.textColor.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppTheme.titleColor,
            width: 2,
          ),
        ),
      ),
      validator: _combineValidators,
    );
  }
}

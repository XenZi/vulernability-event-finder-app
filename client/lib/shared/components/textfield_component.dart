import 'package:client/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? hintText;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final bool hasFocus = Focus.of(context).hasFocus;

          return TextField(
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
              fillColor:
                  AppTheme.textColor.withOpacity(0.1), // Background color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasFocus
                      ? AppTheme.titleColor
                      : Colors.grey, // Focus changes border color
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey, // Default border color
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.titleColor, // Green border on focus
                  width: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

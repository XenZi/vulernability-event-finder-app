import 'package:flutter/material.dart';

class MenuOption {
  final String text;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  MenuOption({
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });
}

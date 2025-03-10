import 'package:client/core/theme/app.theme.dart';
import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback? onPressed;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24.0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.8), // Light circular background
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppTheme.backgroundColor, size: size),
        constraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ), // Reduced button size
      ),
    );
  }
}

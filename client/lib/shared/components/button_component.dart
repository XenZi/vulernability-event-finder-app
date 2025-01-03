import 'package:client/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum ButtonStyleType {
  solid, // Solid green background with white text
  transparent, // Transparent background with green border and white text
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonStyleType styleType;
  // final double? width;
  // final double? height;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.styleType = ButtonStyleType.solid,
  });

  @override
  Widget build(BuildContext context) {
    // Define styles based on the button type
    final ButtonStyle buttonStyle = styleType == ButtonStyleType.solid
        ? ElevatedButton.styleFrom(
            backgroundColor: AppTheme.titleColor, // Green background
            foregroundColor: AppTheme.textColor, // White text
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Transparent background
            foregroundColor: AppTheme.textColor, // White text
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            side: BorderSide(
                color: AppTheme.titleColor, width: 2), // Green border
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            shadowColor:
                Colors.transparent, // Ensure no shadow for transparency
          );

    return SizedBox(
      // width: width,
      // height: height,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppTheme {
  // Define colors
  static const Color backgroundColor = Color(0xFF212428);
  static const Color titleColor = Color(0xFF009E66);
  static const Color textColor = Color(0xFFD3D3D4);
  static const Color darkerBackgroundColor = Color(0xFF1B1D20);

  // Define text styles
  static const TextStyle titleStyle = TextStyle(
    color: titleColor,
    fontSize: 24, // Title size
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    color: textColor,
    fontSize: 16, // Body text size
    fontWeight: FontWeight.normal,
  );

  static const TextStyle smallTextStyle = TextStyle(
    color: textColor,
    fontSize: 12, // Small text size
    fontWeight: FontWeight.normal,
  );

  // Create a ThemeData object
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: titleColor,
      textTheme: const TextTheme(
        displayLarge: titleStyle, // Large titles
        titleLarge: titleStyle, // Page titles
        titleSmall: smallTextStyle, // Smaller text
        bodyLarge: bodyTextStyle, // Regular text
        bodyMedium: bodyTextStyle, // Alternate regular text
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: titleColor,
      textTheme: const TextTheme(
        displayLarge: titleStyle,
        titleLarge: titleStyle,
        bodyLarge: bodyTextStyle,
        bodyMedium: bodyTextStyle,
        titleSmall: smallTextStyle,
      ),
    );
  }
}

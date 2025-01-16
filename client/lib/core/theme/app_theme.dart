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

  // Create a ThemeData object for light theme
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: titleColor,
      appBarTheme: AppBarTheme(
        backgroundColor: darkerBackgroundColor,
        titleTextStyle: titleStyle,
        iconTheme: IconThemeData(color: textColor),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: titleColor,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: const TextTheme(
        headlineLarge: titleStyle, // For large titles
        titleLarge: titleStyle, // For page titles
        bodyLarge: bodyTextStyle, // For regular text
        bodyMedium: bodyTextStyle, // For alternate regular text
        bodySmall: smallTextStyle, // For smaller text
      ),
    );
  }

  // Create a ThemeData object for dark theme
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: titleColor,
      appBarTheme: AppBarTheme(
        backgroundColor: darkerBackgroundColor,
        titleTextStyle: titleStyle,
        iconTheme: IconThemeData(color: textColor),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: titleColor,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: const TextTheme(
        headlineLarge: titleStyle,
        titleLarge: titleStyle,
        bodyLarge: bodyTextStyle,
        bodyMedium: bodyTextStyle,
        bodySmall: smallTextStyle,
      ),
    );
  }
}

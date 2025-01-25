import 'package:flutter/material.dart';

class AppTheme {
  // Define colors
  static const Color backgroundColor =
      Color(0xFF212428); // Darker base background
  static const Color titleColor = Color(0xFF009E66); // Primary accent color
  static const Color textColor = Color(0xFFD3D3D4); // Light text
  static const Color darkerBackgroundColor =
      Color(0xFF1B1D20); // AppBar and section background

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

  // Shared input decoration theme
  static InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: darkerBackgroundColor,
      labelStyle: bodyTextStyle.copyWith(color: textColor),
      hintStyle: bodyTextStyle.copyWith(color: textColor.withOpacity(0.7)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: titleColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: titleColor, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  // Button style
  static ButtonStyle get buttonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: titleColor,
      foregroundColor: textColor,
      textStyle: bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  // Theme for Light Mode
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: titleColor,
      appBarTheme: AppBarTheme(
        backgroundColor: darkerBackgroundColor,
        titleTextStyle: titleStyle,
        iconTheme: const IconThemeData(color: textColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
      inputDecorationTheme: inputDecorationTheme,
      textTheme: const TextTheme(
        headlineLarge: titleStyle, // Large headlines
        titleLarge: titleStyle, // Page titles
        bodyLarge: bodyTextStyle, // Main body text
        bodyMedium: bodyTextStyle, // Alternate body text
        bodySmall: smallTextStyle, // Small text
      ),
      iconTheme: const IconThemeData(color: textColor),
    );
  }

  // Theme for Dark Mode
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: titleColor,
      appBarTheme: AppBarTheme(
        backgroundColor: darkerBackgroundColor,
        titleTextStyle: titleStyle,
        iconTheme: const IconThemeData(color: textColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
      inputDecorationTheme: inputDecorationTheme,
      textTheme: const TextTheme(
        headlineLarge: titleStyle,
        titleLarge: titleStyle,
        bodyLarge: bodyTextStyle,
        bodyMedium: bodyTextStyle,
        bodySmall: smallTextStyle,
      ),
      iconTheme: const IconThemeData(color: textColor),
    );
  }
}

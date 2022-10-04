import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData build() {
    const buttonSize = Size(kMinInteractiveDimension * 3, kMinInteractiveDimension);

    return ThemeData.from(
      colorScheme: const ColorScheme.highContrastDark(
        primary: Colors.yellow,
        secondary: Colors.amber,
      ),
    ).copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: buttonSize,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: buttonSize,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
    );
  }
}

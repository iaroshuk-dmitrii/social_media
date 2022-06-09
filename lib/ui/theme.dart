import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData light = ThemeData(
    colorScheme: const ColorScheme.light().copyWith(primary: Colors.blue),
    textTheme: const TextTheme(
      titleLarge: TextStyle(),
      labelLarge: TextStyle(),
      labelMedium: TextStyle(),
      labelSmall: TextStyle(),
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
      bodySmall: TextStyle(),
    ),
  );
}

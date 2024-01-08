import 'package:flutter/material.dart';

CustomThemeNotifier currentTheme = CustomThemeNotifier();

enum ThemeEnum { cyan, amber }

class CustomThemeNotifier with ChangeNotifier {
  ThemeEnum _themeType = ThemeEnum.amber;

  void updateTheme(ThemeEnum newTheme) {
    _themeType = newTheme;
    notifyListeners();
  }

  ThemeData get colorSchemeBasedTheme {
    switch (_themeType) {
      case ThemeEnum.cyan:
        return cyanAccent;
      default:
        return amberAccent;
    }
  }

  static ThemeData get cyanAccent {
    return ThemeData(
      colorScheme: ColorScheme(
        onPrimary: Colors.cyan.shade900,
        primary: Colors.cyan,
        secondary: Colors.cyan.shade100,
        onSecondary: Colors.cyan.shade100,
        tertiary: Colors.cyan.shade700,
        error: Colors.red,
        onError: Colors.red,
        background: Colors.white,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get amberAccent {
    return ThemeData(
      colorScheme: ColorScheme(
        onPrimary: Colors.amber.shade900,
        primary: Colors.amber,
        secondary: Colors.amber.shade100,
        onSecondary: Colors.amber.shade100,
        tertiary: Colors.amber.shade700,
        error: Colors.red,
        onError: Colors.red,
        background: Colors.white,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }
}

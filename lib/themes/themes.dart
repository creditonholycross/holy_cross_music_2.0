import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalThemeData {
  static const lightRedColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 0, 0, 0),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xFFFAFBFB),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
    tertiary: Color.fromARGB(255, 128, 1, 34),
  );

  static const darkRedColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 255, 255, 255),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color.fromARGB(255, 26, 26, 26),
    onSurface: Color.fromARGB(255, 255, 255, 255),
    brightness: Brightness.dark,
    tertiary: Color.fromARGB(255, 128, 1, 34),
  );

  static const lightGreenColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 0, 0, 0),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xFFFAFBFB),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
    tertiary: Color.fromARGB(255, 1, 128, 1),
  );

  static const darkGreenColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 255, 255, 255),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color.fromARGB(255, 26, 26, 26),
    onSurface: Color.fromARGB(255, 255, 255, 255),
    brightness: Brightness.dark,
    tertiary: Color.fromARGB(255, 1, 128, 1),
  );

  static const lightBlackColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 0, 0, 0),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color.fromARGB(255, 255, 255, 255),
    onSurface: Color.fromARGB(255, 0, 0, 0),
    brightness: Brightness.light,
    tertiary: Color.fromARGB(255, 0, 0, 0),
  );

  static const darkBlackColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 255, 255, 255),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color.fromARGB(255, 26, 26, 26),
    onSurface: Color.fromARGB(255, 255, 255, 255),
    brightness: Brightness.dark,
    tertiary: Color.fromARGB(255, 0, 0, 0),
  );

  static const lightGoldColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 0, 0, 0),
    onPrimary: Colors.black,
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xFFFAFBFB),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
    tertiary: Color.fromARGB(255, 228, 175, 29),
  );

  static const darkGoldColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 255, 255, 255),
    onPrimary: Colors.black,
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color.fromARGB(255, 26, 26, 26),
    onSurface: Color.fromARGB(255, 255, 255, 255),
    brightness: Brightness.dark,
    tertiary: Color.fromARGB(255, 228, 175, 29),
  );

  static const lightPurpleColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 0, 0, 0),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xFFFAFBFB),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
    tertiary: Color.fromARGB(255, 77, 1, 128),
  );

  static const darkPurpleColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 255, 255, 255),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color.fromARGB(255, 26, 26, 26),
    onSurface: Color.fromARGB(255, 255, 255, 255),
    brightness: Brightness.dark,
    tertiary: Color.fromARGB(255, 77, 1, 128),
  );

  static const lightRoseColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 0, 0, 0),
    onPrimary: Colors.black,
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xFFFAFBFB),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
    tertiary: Color.fromARGB(255, 187, 118, 181),
  );

  static const darkRoseColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 255, 255, 255),
    onPrimary: Colors.black,
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color.fromARGB(255, 26, 26, 26),
    onSurface: Color.fromARGB(255, 255, 255, 255),
    brightness: Brightness.dark,
    tertiary: Color.fromARGB(255, 187, 118, 181),
  );

  static const lightWhiteColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 0, 0, 0),
    onPrimary: Colors.black,
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xFFFAFBFB),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
    tertiary: Color.fromARGB(255, 255, 255, 255),
  );

  static const darkWhiteColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 255, 255, 255),
    onPrimary: Color.fromARGB(255, 0, 0, 0),
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color.fromARGB(255, 26, 26, 26),
    onSurface: Color.fromARGB(255, 255, 255, 255),
    brightness: Brightness.dark,
    tertiary: Color.fromARGB(255, 255, 255, 255),
  );

  static ThemeData lightThemeData = ThemeData(
    colorScheme: lightRedColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.white),
  );

  static ThemeData darkThemeData = ThemeData(
    colorScheme: darkRedColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.black),
  );

  static ThemeData lightGreenThemeData = ThemeData(
    colorScheme: lightGreenColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.white),
  );

  static ThemeData darkGreenThemeData = ThemeData(
    colorScheme: darkGreenColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.black),
  );

  static ThemeData lightBlackThemeData = ThemeData(
    colorScheme: lightBlackColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.white),
  );

  static ThemeData darkBlackThemeData = ThemeData(
    colorScheme: darkBlackColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.black),
  );

  static ThemeData lightGoldThemeData = ThemeData(
    colorScheme: lightGoldColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.white),
  );

  static ThemeData darkGoldThemeData = ThemeData(
    colorScheme: darkGoldColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    iconTheme: const IconThemeData(color: Colors.black),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.black),
  );

  static ThemeData lightPurpleThemeData = ThemeData(
    colorScheme: lightPurpleColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.white),
  );

  static ThemeData darkPurpleThemeData = ThemeData(
    colorScheme: darkPurpleColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.black),
  );

  static ThemeData lightRoseThemeData = ThemeData(
    colorScheme: lightRoseColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.white),
  );

  static ThemeData darkRoseThemeData = ThemeData(
    colorScheme: darkRoseColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.black),
  );

  static ThemeData lightWhiteThemeData = ThemeData(
    colorScheme: lightWhiteColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.white),
  );

  static ThemeData darkWhiteThemeData = ThemeData(
    colorScheme: darkWhiteColorScheme,
    useMaterial3: true,
    fontFamily: 'CallunaSans',
    iconTheme: const IconThemeData(color: Colors.black),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    snackBarTheme: const SnackBarThemeData(actionTextColor: Colors.black),
  );

  static Map<String, ThemeData> themeLightMap = {
    'base': lightThemeData,
    'red': lightThemeData,
    'green': lightGreenThemeData,
    'black': lightBlackThemeData,
    'gold': lightGoldThemeData,
    'purple': lightPurpleThemeData,
    'rose': lightRoseThemeData,
    'white': lightWhiteThemeData,
  };

  static Map<String, ThemeData> themeDarkMap = {
    'base': darkThemeData,
    'red': darkThemeData,
    'green': darkGreenThemeData,
    'black': darkBlackThemeData,
    'gold': darkGoldThemeData,
    'purple': darkPurpleThemeData,
    'rose': darkRoseThemeData,
    'white': darkWhiteThemeData,
  };
}

void onThemeChanged(String theme, ApplicationState appState) async {
  appState.setTheme(
    theme,
    GlobalThemeData.themeLightMap[theme] as ThemeData,
    GlobalThemeData.themeDarkMap[theme] as ThemeData,
  );
  var prefs = await SharedPreferences.getInstance();
  prefs.setString('themeName', theme);
}

void getThemeName() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.getString('themeName') ?? 'base';
}

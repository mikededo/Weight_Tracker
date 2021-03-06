import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme { Dark, Light }

final TextTheme textTheme = GoogleFonts.workSansTextTheme();
final TextStyle textStyle = GoogleFonts.workSans();

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.Dark: ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Color(0xFF191924),
    primaryColor: Colors.white,
    primaryColorLight: Color(0xFF202137),
    buttonColor: Colors.orange,
    accentColor: Colors.orange,
    toggleableActiveColor: Colors.orange,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Colors.orange[200],
      selectionHandleColor: Colors.orange,
      cursorColor: Colors.orange,
    ),
    buttonTheme: ButtonThemeData(
      splashColor: Colors.white24,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF3d3e63),
      behavior: SnackBarBehavior.floating,
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    textTheme: textTheme.copyWith(
      // Screen header
      headline1: textStyle.copyWith(
        color: Colors.white,
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
      // Weight tile
      headline2: textStyle.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
      ),
      // Minor titles
      headline3: textStyle.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 28.0,
      ),
      headline4: textStyle.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
        color: Colors.white,
      ),
      headline5: textStyle.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        letterSpacing: 1.0,
      ),
      headline6: textStyle.copyWith(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        letterSpacing: 1.0,
      ),
      bodyText1: textStyle.copyWith(
        color: Colors.white,
        fontSize: 14.0,
        letterSpacing: 0.5,
      ),
      // BMI Tile, Calendar header...
      subtitle1: textStyle.copyWith(
        fontWeight: FontWeight.bold,
        color: Color(0xFF8a8b98),
        letterSpacing: 0.5,
        fontSize: 20.0,
      ),
      subtitle2: textStyle.copyWith(
        color: Colors.grey,
        letterSpacing: 0.5,
        fontSize: 14.0,
      ),
      button: textStyle.copyWith(
        color: Color(0xFF191924),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    ),
  ),
};

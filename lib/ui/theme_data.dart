import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme { Dark, Light }

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.Dark: ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Color(0xFF191924),
    primaryColor: Colors.white,
    primaryColorLight: Color(0xFF202137),
    buttonColor: Colors.orange,
    accentColor: Colors.orange,
    cursorColor: Colors.orange,
    toggleableActiveColor: Colors.orange,
    textSelectionColor: Colors.orange[200],
    textSelectionHandleColor: Colors.orange,
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
    textTheme: GoogleFonts.workSansTextTheme().copyWith(
      // Screen header
      headline1: GoogleFonts.workSans().copyWith(
        color: Colors.white,
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
      // Weight tile
      headline2: GoogleFonts.workSans().copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
      ),
      // Minor titles
      headline3: GoogleFonts.workSans().copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 28.0,
      ),
      headline4: GoogleFonts.workSans().copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
        color: Colors.white,
      ),
      headline5: GoogleFonts.workSans().copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        letterSpacing: 1.0,
      ),
      headline6: GoogleFonts.workSans().copyWith(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        letterSpacing: 1.0,
      ),
      bodyText1: GoogleFonts.workSans().copyWith(
        color: Colors.white,
        fontSize: 14.0,
        letterSpacing: 0.5,
      ),
      // BMI Tile, Calendar header...
      subtitle1: GoogleFonts.workSans().copyWith(
        fontWeight: FontWeight.bold,
        color: Color(0xFF8a8b98),
        letterSpacing: 0.5,
        fontSize: 20.0,
      ),
      button: GoogleFonts.workSans().copyWith(
        color: Color(0xFF191924),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    ),
  ),
};

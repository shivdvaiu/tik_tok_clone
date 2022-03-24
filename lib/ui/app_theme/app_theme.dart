import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColorLight: Colors.white,
      primaryColorDark: Color(0xFF181b45),
      colorScheme: ColorScheme(
        primary: Colors.white,
        primaryVariant: Colors.white,
        secondary:  Color.fromARGB(255, 202, 57, 54),
        secondaryVariant: Colors.white,
        background: Colors.white,
        brightness: Brightness.light,
        error: Colors.red,
        onBackground: Colors.white,
        onError: Colors.red,
        onSecondary: Colors.white,
        onPrimary: Colors.black,
        onSurface: Colors.white,
        surface: Color.fromARGB(255, 209, 84, 82),
        
      ),

      ///text theme
      textTheme: GoogleFonts.openSansTextTheme().copyWith(
        bodyText1: TextStyle(
            fontSize: 13.sp, color: Colors.grey, fontWeight: FontWeight.w400),
        bodyText2: TextStyle(fontSize: 13.sp, color: Colors.black,fontWeight: FontWeight.w400),
        headline6: TextStyle(fontSize: 18.0),
        button: TextStyle(fontSize: 16.0, letterSpacing: 1),
        subtitle2: TextStyle(),
        headline3: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
      ));

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColorDark: Colors.white,
      colorScheme: ColorScheme(
        primary: Colors.white,
       primaryContainer: Color(0xff191919),
        secondary: Color.fromARGB(255, 202, 57, 54),
        secondaryVariant: Color(0xff191A19),
        background: Color(0xff040303),
        brightness: Brightness.light,
        error: Colors.red,
        onBackground: Colors.white,
        onError: Colors.red,
        onSecondary: Colors.white,
        onPrimary: Colors.white,
        onSurface: Colors.white,
        surface: Colors.white,

      ),

      ///text theme
      textTheme: GoogleFonts.openSansTextTheme().copyWith(
        bodyText1: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey.withOpacity(0.7),
            fontWeight: FontWeight.w400),
        bodyText2: TextStyle(fontSize: 13.sp, color: Colors.white,fontWeight: FontWeight.w400),
        headline6: TextStyle(fontSize: 18.0),
        button: TextStyle(fontSize: 16.0, letterSpacing: 1),
        subtitle2: TextStyle(),
        headline3: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
      ));
}

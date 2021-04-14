import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class MyTheme {
  static ThemeData light(Color themeColor) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
        color: themeColor,
        textTheme: getTextTheme(),
      ),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.black,
        labelColor: Colors.red,
      ),
      brightness: Brightness.light,
      primaryColorBrightness: Brightness.light,
      primaryColor: themeColor,
      accentColor: themeColor,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: themeColor,
        selectionColor: themeColor,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: getTextTheme(),
      buttonTheme: ButtonThemeData(
        buttonColor: themeColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            // backgroundColor: themeColor,
            // textStyle: TextStyle(
            //   color: Colors.white,
            // ),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(
            //     width(16),
            //   ),
            // ),
            ),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: themeColor,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }

  static ThemeData dark(Color themeColor) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        elevation: 0,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        color: themeColor,
        textTheme: getTextTheme(true),
      ),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.black,
        labelColor: Colors.red,
      ),
      brightness: Brightness.dark,
      primaryColorBrightness: Brightness.dark,
      primaryColor: themeColor,
      accentColor: themeColor,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: themeColor,
        selectionColor: themeColor,
      ),
      scaffoldBackgroundColor: Colors.black,
      textTheme: getTextTheme(true),
      buttonTheme: ButtonThemeData(
        buttonColor: themeColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            // backgroundColor: themeColor,
            // textStyle: TextStyle(
            //   color: Colors.white,
            // ),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(
            //     width(16),
            //   ),
            // ),
            ),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: themeColor,
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }

  static TextTheme getTextTheme([isDark = false]) {
    Color textColor = isDark ? Colors.white : Color(0xff25282B);
    return TextTheme(
      headline1: TextStyle(
        fontSize: 52,
        height: 64 / 52,
        letterSpacing: 0.2,
        fontWeight: FontWeight.w300,
        color: textColor,
      ),
      headline2: TextStyle(
        fontSize: 44,
        height: 54 / 44,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      headline3: TextStyle(
        fontSize: 32,
        height: 40 / 32,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headline4: TextStyle(
        fontSize: 26,
        height: 32 / 26,
        letterSpacing: 0.2,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      headline5: TextStyle(
        fontSize: 20,
        height: 26 / 20,
        letterSpacing: 0.2,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headline6: TextStyle(
        fontSize: 18,
        height: 24 / 18,
        letterSpacing: 0.2,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      subtitle1: TextStyle(
        fontSize: 16,
        height: 24 / 16,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        height: 24 / 16,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        height: 22 / 14,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      button: TextStyle(
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: 0.2,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      overline: TextStyle(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.2,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';

BuildContext globalContext;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final double statusBarHeight = MediaQueryData.fromWindow(window).padding.top;

final double bottomAreaHeight = MediaQueryData.fromWindow(window).padding.bottom;

final double dpr = MediaQueryData.fromWindow(window).devicePixelRatio;

double vw = MediaQueryData.fromWindow(window).size.width;

double vh = MediaQueryData.fromWindow(window).size.height;

final bool isSystemDark = MediaQueryData.fromWindow(window).platformBrightness==Brightness.dark;

final List<ThemeMode> themeModeList = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];

final List<Color> themeList = [
  Color(0xff99CCFF),
  Color(0xffffffff),
  Color(0xff8bd666),
  Color(0xffFF9999),
];

final List<Color> darkThemeList = [
  Color(0xff003366),
  Color(0xff242424),
  Color(0xff006600),
  Color(0xff660000),
];

String durationToTime(Duration duration) {
  int h = duration.inHours;
  int m = duration.inMinutes.remainder(60);
  int s = duration.inSeconds.remainder(60);
  return '${h>0?h.toString()+':':''}${m<10?'0'+m.toString():m}:${s<10?'0'+s.toString():s}';
}

String generateToken(String appid, String secretKey, String shortid) {
  int expiredTime = DateTime(2019, 7, 13).millisecondsSinceEpoch~/100;
  final rawMask = '${appid}_${expiredTime}_$secretKey';
  final mask = Hmac(sha1, utf8.encode(secretKey)).convert(utf8.encode(rawMask));
  final token = '$shortid:$expiredTime:$mask';
//    ws://apiv0.fantaiai.com/ws
//
//    appid: 2868a8490a6311e9854d0242ac640010
//    secret_key: j3KlisUhyZpO
//    shortid: 0000000b
  return token;
}

double width(num w) {
  return ScreenUtil().setWidth(w).toDouble();
}
double height(num h) {
  return ScreenUtil().setHeight(h).toDouble();
}

class MyTheme {
  static ThemeData light(Color themeColor) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        elevation: 0,
        brightness: Brightness.light,
        textTheme: TextTheme(
          bodyText1: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.black,
          ),
          button: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
        color: themeColor,
      ),
      brightness: Brightness.light,
      primaryColorBrightness: Brightness.light,
      primaryColor: themeColor,
      accentColor: themeColor,
      cursorColor: themeColor,
      textSelectionColor: themeColor,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.black,
        ),
        button: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.black,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: themeColor,
      ),
      iconTheme: IconThemeData(
        color: Colors.black
      ),
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
        textTheme: TextTheme(
          bodyText1: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.white,
          ),
          button: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        color: themeColor,
      ),
      brightness: Brightness.dark,
      primaryColorBrightness: Brightness.dark,
      primaryColor: themeColor,
      accentColor: themeColor,
      cursorColor: themeColor,
      textSelectionColor: themeColor,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white,
        ),
        button: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: themeColor,
      ),
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: themeColor,
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }
}

void setViewPort() {
  vw = MediaQueryData.fromWindow(window).size.width;

  vh = MediaQueryData.fromWindow(window).size.height;
}
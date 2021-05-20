import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
export './iconfont.dart';

GlobalKey rootKey = GlobalKey();

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

OverlayState? globalOverlayState;

BuildContext? globalContext;

double statusBarHeight = MediaQueryData.fromWindow(window).padding.top;

double bottomAreaHeight = MediaQueryData.fromWindow(window).padding.bottom;

double dpr = MediaQueryData.fromWindow(window).devicePixelRatio;

double vw = MediaQueryData.fromWindow(window).size.width;

double vh = MediaQueryData.fromWindow(window).size.height;

bool isSystemDark =
    MediaQueryData.fromWindow(window).platformBrightness == Brightness.dark;

final List<ThemeMode> themeModeList = [
  ThemeMode.system,
  ThemeMode.light,
  ThemeMode.dark
];

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

String generateToken(String appid, String secretKey, String shortid) {
  int expiredTime = DateTime(2019, 7, 13).millisecondsSinceEpoch ~/ 100;
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

void uiInit(BuildContext context) {
  final BuildContext _context = context;

  final Orientation currentOrientation = MediaQuery.of(_context).orientation;

  if (currentOrientation == Orientation.portrait) {
    vw = MediaQuery.of(_context).size.width;

    vh = MediaQuery.of(_context).size.height;
  }

  statusBarHeight = MediaQuery.of(_context).padding.top;

  bottomAreaHeight = MediaQuery.of(_context).padding.bottom;

  dpr = MediaQuery.of(_context).devicePixelRatio;

  isSystemDark = MediaQuery.of(_context).platformBrightness == Brightness.dark;

  //
  globalContext = _context;

  globalOverlayState = Overlay.of(_context);

  ScreenUtil.init(
    BoxConstraints.tightFor(
      width: MediaQuery.of(_context).size.width,
      height: MediaQuery.of(_context).size.height,
    ),
    orientation: Orientation.portrait,
    designSize: Size(750, 1134),
  );
}

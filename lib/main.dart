import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:amap_location/amap_location.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_play/pages/entry.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orientation/orientation.dart';
import 'package:statusbar_util/statusbar_util.dart';
import 'package:device_info/device_info.dart';

import 'router.dart';
import 'routeObserver.dart';
import 'package:flutter_play/store/model.dart';
import 'variable.dart';
import 'utils/chinese_localization.dart';
import 'service.dart';

//import 'pages/global/splash.dart';
import 'pages/global/splashBanner.dart';


void main() async {
  // runApp之前调用api的预初始化
  WidgetsFlutterBinding.ensureInitialized();
  // 禁用provider的debug
  Provider.debugCheckInvalidValueType = null;
  // 沉浸式状态栏
  StatusbarUtil.setTranslucent();
  // 设置竖屏
  OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
  setViewPort();
  // 获取uuid
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // ios高德
    AMapLocationClient.setApiKey("bfea8a8172612b2f2de52e256fcdbc66");
    IosDeviceInfo info = await deviceInfo.iosInfo;
//    print(info);
  }
  if (Platform.isAndroid) {
    AndroidDeviceInfo info = await deviceInfo.androidInfo;
//    print(info.hardware);
//    print(info.manufacturer);
  }
  // 配置路由
  final router = Router();
  RouterManager.defineRoutes(router);
  RouterManager.router = router;
  await Future.delayed(Duration(seconds: 2));
  // 监听网络变化
  // 配置dio
  Service.init();


  // 获取缓存主题
  int themeIndex = await getTheme();
  // 获取缓存的内部主题模式
  int themeModeIndex = await getThemeMode();

  // 判断是否需要splash
  SharedPreferences sp = await SharedPreferences.getInstance();

  runApp(MyApp(
    splashed: sp.getBool("splash")??false,
    useSystemMode: themeModeIndex==0,
    themeMode: themeModeList[themeModeIndex],
    themeIndex: themeIndex,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({
    this.splashed,
    this.useSystemMode,
    this.themeMode,
    this.themeIndex,
  }) {
    // 初始化全局model
    this.globalModel = GlobalModel(
      useSystemMode: useSystemMode,
      themeMode: themeMode,
      systemThemeMode: isSystemDark?ThemeMode.dark:ThemeMode.light
    );
  }
  final bool splashed;

  final bool useSystemMode;

  final ThemeMode themeMode;

  final int themeIndex;

  GlobalModel globalModel;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: globalModel)
      ],
      child: Consumer<GlobalModel>(
        builder: (context, model, child) {
          final Color themeColor = (model.isDark?darkThemeList:themeList)[model.themeIndex!=null?model.themeIndex:themeIndex];
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: MyTheme.light(themeColor),
            darkTheme: MyTheme.dark(themeColor),
            themeMode: model.useSystemMode?ThemeMode.system:model.appThemeMode,
            home: splashed?EntryPage():SplashBanner(),
            navigatorKey: navigatorKey,
            onGenerateRoute: RouterManager.router.generator,
            navigatorObservers: <NavigatorObserver>[
              MyRouteObserve(),
            ],
            supportedLocales: [
              Locale('zh', ''),
              Locale('en', 'US'), // English
              Locale('zh', 'Hans'), // China
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              ChineseCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}

Future<int> getTheme() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  int themeIndex = sp.getInt('themeIndex');
  if (themeIndex!=null) {
    return themeIndex;
  }
  return 0;
}

Future<int> getThemeMode() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  int index = sp.getInt('appThemeMode')??1;
  bool useSystemMode = sp.getBool('useSystemMode')??false;
  if (useSystemMode) return 0;
  return index;
}

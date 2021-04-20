import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_play/mainAgreement.dart';
import 'package:flutter_play/pages/entry.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart';
import 'package:home_indicator/home_indicator.dart';
import 'package:mob/mob.dart';
import 'package:move_bg/move_bg.dart';
import 'package:flutter_orientation/flutter_orientation.dart';

import 'package:flutter_play/theme/theme.dart';
import 'locale/locale.dart';
import 'router/routeObserver.dart';
import 'router/routes.dart';
import 'package:flutter_play/store/model.dart';
import 'variable.dart';
import 'service/service.dart';

//import 'pages/global/splash.dart';
import 'pages/global/splashBanner.dart';

void main() async {
  try {
    // runApp之前调用api的预初始化
    WidgetsFlutterBinding.ensureInitialized();
    // 沉浸式状态栏
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    // 设置竖屏 lock
    HomeIndicator.deferScreenEdges([]);
    FlutterOrientation.setOrientation(DeviceOrientation.portraitUp);
    // 监听网络变化
    // 配置dio
    Service.init();
    // storage
    await GetStorage.init();

    // 启动页显示2秒
    await Future.delayed(Duration(seconds: 2));

    GetStorage storage = GetStorage();
    bool agree = storage.read('agree') ?? false;
    if (!agree) {
      // 是否没同意隐私协议
      runApp(MainAgreement());
    } else {
      startApp();
    }
  } catch (e) {
    print(e);
  }
}

Future<void> startApp() async {
  // init wx
  registerWxApi(
    appId: 'wx9819a39d04a4253f',
    universalLink: 'https://applink.chavesgu.com/flutter/',
  ).then((value) {
    // print(value);
  });
  // mob server init
  Mob.init();
  // get control
  Get.put(GlobalModel());
  Get.put(UserModel());
  GetStorage storage = GetStorage();
  // 获取缓存主题
  int themeIndex = await getTheme();
  // 获取缓存的内部主题模式
  int themeModeIndex = await getThemeMode();
  // 获取缓存语言
  Map<String, String> locale = storage.read('locale') ??
      {
        'languageCode': 'zh',
        'countryCode': 'CN',
      };
  runApp(MyApp(
    splashed: storage.read("splash") ?? false,
    useSystemMode: themeModeIndex == 0,
    themeMode: themeModeList[themeModeIndex],
    themeIndex: themeIndex,
    locale: Locale(locale['languageCode']!, locale['countryCode']),
  ));
}

Future<int> getTheme() async {
  GetStorage storage = GetStorage();
  int? themeIndex = storage.read('themeIndex');
  return themeIndex ?? 0;
}

Future<int> getThemeMode() async {
  GetStorage storage = GetStorage();
  int index = storage.read('appThemeMode') ?? 1;
  bool useSystemMode = storage.read('useSystemMode') ?? false;
  if (useSystemMode) return 0;
  return index;
}

class MyApp extends StatelessWidget {
  MyApp({
    this.splashed = false,
    this.locale,
    required this.useSystemMode,
    required this.themeMode,
    required this.themeIndex,
  });

  final bool splashed;

  final Locale? locale;

  final bool useSystemMode;

  final ThemeMode themeMode;

  final int themeIndex;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeModel>(
      init: ThemeModel(
        useSystemMode: useSystemMode,
        themeMode: themeMode,
        systemThemeMode: isSystemDark ? ThemeMode.dark : ThemeMode.light,
      ),
      builder: (model) {
        final Color themeColor = (model.isDark ? darkThemeList : themeList)[
            model.themeIndex != null ? model.themeIndex! : themeIndex];
        return GetMaterialApp(
          key: rootKey,
          debugShowCheckedModeBanner: false,
          theme: MyTheme.light(themeColor),
          darkTheme: MyTheme.dark(themeColor),
          themeMode:
              model.useSystemMode ? ThemeMode.system : model.appThemeMode,
          initialRoute: splashed ? EntryPage.name : SplashBanner.name,
          getPages: routes,
          navigatorObservers: <NavigatorObserver>[
            MyRouteObserve(),
          ],
          translations: GetLocale(), // 你的翻译
          locale: locale, // 将会按照此处指定的语言翻译
          fallbackLocale: Locale('en'), // 添加一个回调语言选项，以备上面指定的语言翻译不存在
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          // home: EntryPage(),
        );
      },
    );
  }
}

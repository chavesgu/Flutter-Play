import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_play/theme/theme.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_play/mainAgreement.dart';
import 'package:flutter_play/pages/entry.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart';
import 'package:home_indicator/home_indicator.dart';
import 'package:mob/mob.dart';
import 'package:move_bg/move_bg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_orientation/flutter_orientation.dart';

import 'generated/l10n.dart';
import 'router/router.dart';
import 'router/routeObserver.dart';
import 'package:flutter_play/store/model.dart';
import 'variable.dart';
import 'service/service.dart';

//import 'pages/global/splash.dart';
import 'pages/global/splashBanner.dart';

void main() async {
  try {
    // runApp之前调用api的预初始化
    WidgetsFlutterBinding.ensureInitialized();
    // 禁用provider的debug
    Provider.debugCheckInvalidValueType = null;
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

    // 启动页显示2秒
    await Future.delayed(Duration(seconds: 2));

    SharedPreferences sp = await SharedPreferences.getInstance();
    bool agree = sp.getBool('agree') ?? false;
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeModel(
              useSystemMode: useSystemMode,
              themeMode: themeMode,
              systemThemeMode: isSystemDark ? ThemeMode.dark : ThemeMode.light),
        ),
        ChangeNotifierProvider(
          create: (_) => GlobalModel(
            locale: locale,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => UserModel(),
        )
      ],
      child: Consumer<ThemeModel>(
        builder: (context, model, child) {
          final Color themeColor = (model.isDark ? darkThemeList : themeList)[
              model.themeIndex != null ? model.themeIndex! : themeIndex];
          return MaterialApp(
            key: rootKey,
            debugShowCheckedModeBanner: false,
            theme: MyTheme.light(themeColor),
            darkTheme: MyTheme.dark(themeColor),
            themeMode:
                model.useSystemMode ? ThemeMode.system : model.appThemeMode,
            navigatorKey: navigatorKey,
            onGenerateRoute: RouterManager.router!.generator,
            navigatorObservers: <NavigatorObserver>[
              MyRouteObserve(),
            ],
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              S.delegate,
            ],
            home: WillPopScope(
              onWillPop: () async {
                bool canPop = navigatorKey.currentState!.canPop();
                if (canPop) return true;
                if (Platform.isAndroid) {
                  MoveBg.run();
                }
                return false;
              },
              child: LayoutBuilder(
                builder: (_context, _constraints) {
                  uiInit(_context, _constraints);
                  WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                    context
                        .read<GlobalModel>()
                        .changeOrientation(MediaQuery.of(_context).orientation);
                  });
                  return splashed ? EntryPage() : SplashBanner();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<void> startApp() async {
  // 配置路由
  RouterManager.init();
  // init wx
  registerWxApi(
          appId: 'wx9819a39d04a4253f',
          universalLink: 'https://applink.chavesgu.com/flutter/')
      .then((value) {
    // print(value);
  });
  // mob server init
  Mob.init();
  SharedPreferences sp = await SharedPreferences.getInstance();
  // 获取语言
  String? localeJson = sp.getString("locale");
  Locale? locale = localeJson != null
      ? Locale.fromSubtags(
          languageCode: jsonDecode(localeJson)['languageCode'],
          scriptCode: jsonDecode(localeJson)['scriptCode'],
        )
      : null;
  // 获取缓存主题
  int themeIndex = await getTheme();
  // 获取缓存的内部主题模式
  int themeModeIndex = await getThemeMode();
  runApp(MyApp(
    splashed: sp.getBool("splash") ?? false,
    locale: locale,
    useSystemMode: themeModeIndex == 0,
    themeMode: themeModeList[themeModeIndex],
    themeIndex: themeIndex,
  ));
}

Future<int> getTheme() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  int? themeIndex = sp.getInt('themeIndex');
  return themeIndex ?? 0;
}

Future<int> getThemeMode() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  int index = sp.getInt('appThemeMode') ?? 1;
  bool useSystemMode = sp.getBool('useSystemMode') ?? false;
  if (useSystemMode) return 0;
  return index;
}

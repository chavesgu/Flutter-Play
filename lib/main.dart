import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart';
import 'package:home_indicator/home_indicator.dart';
import 'package:mob/mob.dart';
import 'package:flutter_orientation/flutter_orientation.dart';
import 'components/GlobalComponents.dart';
import 'package:flutter_play/theme/theme.dart';
import 'router/routeObserver.dart';
import 'router/routes.dart';
import 'package:flutter_play/store/model.dart';
import 'variable.dart';
import 'service/service.dart';
import 'locale/locale.dart';

import 'package:flutter_play/mainAgreement.dart';
import 'package:flutter_play/router/path.dart';
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
    Get.isLogEnable = false;
    // clear image cache
    // MyImage.clear();

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
    runApp(Scaffold(
      body: Center(
        child: Text(e.toString()),
      ),
    ));
  }
}

Future<void> startApp() async {
  // sw
  setSW();
  // init wx
  registerWxApi(
    appId: 'wx9819a39d04a4253f',
    universalLink: 'https://applink.chavesgu.com/flutter/',
  ).then((value) {
    // print(value);
  });
  // mob server init
  Mob.init();
  Mob.isSupportLogin.then((value) {
    if (value) Mob.prelogin();
  });
  // get control
  GetStorage storage = GetStorage();
  // 获取缓存主题
  int themeIndex = await getTheme();
  // 获取缓存的内部主题模式
  int themeModeIndex = await getThemeMode();
  Get.put(ThemeModel(
    useSystemMode: themeModeIndex == 0,
    themeMode: themeModeList[themeModeIndex],
    themeIndex: themeIndex,
  ));
  Get.put(GlobalModel());
  Get.put(UserModel());
  // 获取缓存语言
  Map<String, dynamic> locale = storage.read('locale') ??
      {
        'languageCode': 'zh',
        'countryCode': 'CN',
      };
  runApp(MyApp(
    splashed: storage.read("splash") ?? false,
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

void setSW() async {
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();
      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          // print(request);
          return null;
        },
      );
    }
  }
}

class MyApp extends StatelessWidget {
  MyApp({
    this.splashed = false,
    required this.locale,
  });
  final bool splashed;
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeModel>(
      builder: (model) {
        final Color themeColor =
            (model.isDark ? darkThemeList : themeList)[model.themeIndex!];
        return GetMaterialApp(
          key: rootKey,
          enableLog: false,
          debugShowCheckedModeBanner: false,
          theme: MyTheme.light(themeColor),
          darkTheme: MyTheme.dark(themeColor),
          themeMode:
              model.useSystemMode ? ThemeMode.system : model.appThemeMode,
          initialRoute: splashed ? EntryPage.name : SplashBanner.name,
          getPages: routes,
          transitionDuration: Duration(milliseconds: 400),
          navigatorObservers: <NavigatorObserver>[
            MyRouteObserve(),
          ],
          locale: locale, // 将会按照此处指定的语言翻译
          fallbackLocale: GetLocale.defaultLocale, // 添加一个回调语言选项，以备上面指定的语言翻译不存在
          supportedLocales: GetLocale.supportedLocales,
          translations: GetLocale(), // 你的翻译
          localizationsDelegates: GetLocale.delegate,
          // home: EntryPage(),
        );
      },
    );
  }
}

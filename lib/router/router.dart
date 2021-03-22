import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'path.dart';

class RouterManager {
  static MyRouter? router;

  static init() {
    if (router == null) {
      router = MyRouter();
      _defineRoutes(router!);
    }
    return router;
  }

  static _defineRoutes(FluroRouter router) {
    // app入口
    router.define(
      EntryPage.name,
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return EntryPage();
      }),
      transitionType: TransitionType.fadeIn,
    );
    // 搜索页
    router.define(
      SearchPage.name,
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return SearchPage(params["text"]?.first);
      }),
      transitionType: TransitionType.cupertino,
    );
    // 扫描二维码页
    router.define(
      ScanPage.name,
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return ScanPage();
      }),
      transitionType: TransitionType.cupertino,
    );
    // 设置页
    router.define(
      SettingPage.name,
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return SettingPage();
      }),
      transitionType: TransitionType.cupertino,
    );

    // demo-fixed
    router.define(
      TestFixedPage.name,
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return TestFixedPage();
      }),
      transitionType: TransitionType.cupertino,
    );
    // pdf
    router.define(
      PDFView.name,
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return PDFView(params["url"].first);
      }),
      transitionType: TransitionType.cupertino,
    );
    // WebView
    router.define(
      MyWebView.name,
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return MyWebView(params["url"]?.first);
      }),
      transitionType: TransitionType.cupertino,
    );
    // canvas
    router.define(
      CanvasPage.name,
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return CanvasPage();
      }),
      transitionType: TransitionType.cupertino,
    );
    // canvas
    router.define(
      CanvasPage2.name,
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return CanvasPage2();
      }),
      transitionType: TransitionType.cupertino,
    );
    // canvas
    router.define(
      ChartDemo.name,
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return ChartDemo();
      }),
      transitionType: TransitionType.cupertino,
    );
    // video detail
    router.define(
      VideoDetailPage.name,
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return VideoDetailPage();
      }),
      transitionType: TransitionType.cupertino,
    );
    // audio detail
    router.define(
      AudioDetailPage.name,
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        return AudioDetailPage(
          jsonDecode(params["list"]?.first) ?? [],
          current: int.parse(params["current"]?.first),
        );
      }),
      transitionType: TransitionType.cupertinoFullScreenDialog,
    );

    // 404
//    router.notFoundHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
//      return 404;
//    });
  }
}

class MyRouter extends FluroRouter {
  @override
  Route? generator(RouteSettings routeSettings) {
    return super.generator(routeSettings);
  }
}

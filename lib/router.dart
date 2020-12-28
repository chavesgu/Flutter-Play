import 'package:flutter/material.dart' hide Router;
import 'package:fluro/fluro.dart';
import 'package:flutter_play/store/model.dart';
import 'package:flutter_play/variable.dart';
import 'package:provider/provider.dart';

import 'routerPath.dart';


class RouterManager {
  static MyRouter router;

  static init() {
    if (router==null) {
      router = MyRouter();
      _defineRoutes(router);
    }
    return router;
  }

  static _defineRoutes(Router router) {
    // app入口
    router.define(
      EntryPage.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return EntryPage();
      }),
      transitionType:  TransitionType.fadeIn,
    );
    // 搜索页
    router.define(
      SearchPage.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return SearchPage(params["text"]?.first);
      }),
      transitionType:  TransitionType.cupertino,
    );
    // 扫描二维码页
    router.define(
      ScanPage.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return ScanPage();
      }),
      transitionType:  TransitionType.cupertino,
    );
    // 排行榜
    router.define(
      TopListPage.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return TopListPage();
      }),
      transitionType:  TransitionType.cupertino,
    );
    // 歌单详情
    router.define(
      MusicListDetailPage.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return MusicListDetailPage(params["id"].first);
      }),
      transitionType:  TransitionType.cupertino,
    );
    // 关于我们页
    router.define(
      AboutPage.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return AboutPage(params["url"].first);
      }),
      transitionType:  TransitionType.cupertino,
    );
    // 设置页
    router.define(
      SettingPage.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return SettingPage();
      }),
      transitionType:  TransitionType.cupertino,
    );

    // demo-fixed
    router.define(
      TestFixedPage.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return TestFixedPage();
      }),
      transitionType:  TransitionType.cupertino,
    );
    // test ocr
    router.define(
      TestOCR.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return TestOCR();
      }),
      transitionType:  TransitionType.cupertino,
    );
    // pdf
    router.define(
      PDFView.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return PDFView(params["url"].first);
      }),
      transitionType:  TransitionType.cupertino,
    );
    // WebView
    router.define(
      WebView.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return WebView(params["url"].first);
      }),
      transitionType:  TransitionType.cupertino,
    );
    // canvas
    router.define(
      CanvasPage.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return CanvasPage();
      }),
      transitionType:  TransitionType.cupertino,
    );
    // canvas
    router.define(
      CanvasPage2.name,
      handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return CanvasPage2();
      }),
      transitionType:  TransitionType.cupertino,
    );

    // 404
//    router.notFoundHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
//      return 404;
//    });
  }
}

class MyRouter extends Router {
  @override
  Route generator(RouteSettings routeSettings) {
    // TODO: implement generator
    if (globalContext!=null) {
      // print(Provider.of<UserModel>(globalContext, listen: false).title);
    }
    return super.generator(routeSettings);
  }
}
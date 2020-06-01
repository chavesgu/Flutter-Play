import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'routerPath.dart';


class RouterManager {
  static Router router;

  static defineRoutes(Router router) {
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

    // 404
//    router.notFoundHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
//      return 404;
//    });
  }
}
import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import 'variable.dart';

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

final Dio simple = Dio(BaseOptions(
  sendTimeout: 60000,
  receiveTimeout: 60000,
));
final Dio api = Dio(BaseOptions(
  baseUrl: 'https://api.chavesgu.com',
  sendTimeout: 60000,
  receiveTimeout: 60000,
  responseType: ResponseType.json,
));

abstract class Service {
  static init() {
    (api.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    api.interceptors.add(CookieManager(CookieJar()));
    api.interceptors.add(InterceptorsWrapper(
      onRequest:(RequestOptions options) {
        options.contentType = Headers.formUrlEncodedContentType;
//        options.contentType = Headers.jsonContentType;
        return options;
      },
      onResponse:(Response response) {
        return response;
      },
      onError: (DioError e) {
// Do something with response error
        print('==========数据响应错误==========');
        print('==========$e==========');
        print('==============================');
        return e;
      }
    ));
  }

  // 首页轮播图
  static Future<List> getHomeBanner() async {
    try {
      Response res = await api.post(
        '/music/banner',
        data: {
          "type": Platform.isIOS?2:1,
        }
      );
      return res.data["banners"];
    } on DioError catch(e) {
      return Future.error(e);
    }
  }
  // 推荐歌单
  static Future<List> getRecommendMusicList() async {
    try {
      Response res = await api.post(
        '/music/personalized',
        data: {
          "limit": 6
        }
      );
      return res.data["result"];
    } on DioError catch(e) {
      return Future.error(e);
    }
  }
  // 排行榜
  static Future<List> getTopList() async {
    try {
      Response res = await api.post(
        '/music/toplist/detail',
      );
      return res.data["list"];
    } on DioError catch(e) {
      return Future.error(e);
    }
  }
  // 歌单详情
  static Future<Map<String, dynamic>> getMusicListDetail(String id) async {
    try {
      Response res = await api.post(
        '/music/playlist/detail?timestamp=${DateTime.now()}',
        data: {
          "id": id
        }
      );
      return res.data["playlist"];
    } on DioError catch(e) {
      return Future.error(e);
    }
  }

  static Future getMusic() {
    return api.post(
      '/music/song/url',
      data: {
        "id": "347230"
      }
    );
  }

  static Future download(String url, String savePath) async {
    try {
      Response res = await simple.download(
        url,
        savePath,
        options: Options(
          responseType: ResponseType.bytes
        )
      );
      return res.data;
    } on DioError catch(e) {
      return Future.error(e);
    }
  }
}
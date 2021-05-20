import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';

Dio createApi({
  String? method,
  int connectTimeout = 60000,
  int receiveTimeout = 60000,
  int sendTimeout = 60000,
  String baseUrl = '',
  Map<String, dynamic>? queryParameters,
  Map<String, dynamic>? extra,
  Map<String, dynamic>? headers,
  ResponseType responseType = ResponseType.json,
  String contentType = Headers.formUrlEncodedContentType,
  ValidateStatus? validateStatus,
  bool receiveDataWhenStatusError = true,
  bool followRedirects = true,
  int maxRedirects = 5,
  RequestEncoder? requestEncoder,
  ResponseDecoder? responseDecoder,
  bool http2 = false,
}) {
  BaseOptions baseOptions = BaseOptions(
    method: method,
    baseUrl: baseUrl,
    queryParameters: queryParameters,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
    sendTimeout: sendTimeout,
    extra: extra,
    headers: headers,
    responseType: responseType,
    contentType: contentType,
    validateStatus: validateStatus,
    receiveDataWhenStatusError: receiveDataWhenStatusError,
    followRedirects: followRedirects,
    maxRedirects: maxRedirects,
    requestEncoder: requestEncoder,
    responseDecoder: responseDecoder,
  );
  final Dio dio = Dio(baseOptions);
  if (http2) {
    dio.httpClientAdapter = Http2Adapter(ConnectionManager(idleTimeout: 60000));
  }
  (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
  // (api.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
  //   client.findProxy = (uri) {
  //     return "PROXY localhost:8888";
  //   };
  //   // you can also create a new HttpClient to dio
  //   // return new HttpClient();
  // };
  // dio.interceptors.add(LogInterceptor(
  //   request: false,
  //   requestHeader: false,
  //   requestBody: false,
  //   responseHeader: false,
  //   responseBody: false,
  // )); //开启请求日志
  dio.interceptors.add(CookieManager(CookieJar()));
  return dio;
}

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

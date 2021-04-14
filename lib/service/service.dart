import 'dart:io';
import 'package:dio/dio.dart';
import './api.dart';
import '../utils/extension.dart';

Dio? simple;
Dio? api;

abstract class Service {
  static init() {
    simple = createApi();
    api = createApi(baseUrl: 'https://api.chavesgu.com');
  }

  static Future<Map<String, dynamic>> geoCoder(
      {required double longitude, required double latitude}) async {
    try {
      Response res = await api!.get(
          '/getLocation/?key=MXKBZ-4Z7CU-AAHVO-2IZNV-M2OLF-4YBCJ&location=$latitude,$longitude');
      return {
        'address': res.data.address,
        'address_component': res.data.address_component,
        'format_address':
            res.data.formatted_addresses?.recommend ?? res.data.address,
      };
    } catch (e) {
      return {};
    }
  }

  // music list  /song/url
  static Future<List> getHotMusic() async {
    try {
      Response res1 = await api!.get('/music/playlist/detail?id=3778678');
      List<dynamic> tracks = res1.data['playlist']['trackIds'];
      List res2 =
          await getMusicDetail(tracks.map<int>((e) => e["id"]).toList());
      return res2;
    } catch (e) {
      return [];
    }
  }

  static Future<List> getMusicDetail(List<int> list) async {
    try {
      Response res2 =
          await api!.get('/music/song/detail?ids=${list.join(',')}');
      return res2.data['songs'];
    } catch (e) {
      return [];
    }
  }

  // 活力73
  static Future<List> getHuoLi73Data() async {
    try {
      Response res = await simple!.get(
          'https://home-files.fantaiai.com/health-wallet/hlindex/hl000002.json?time=${DateTime.now().formatter('yyyyMMdd')}');
      return res.data;
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  static Future download(String url, String savePath,
      {ProgressCallback? onReceiveProgress, CancelToken? cancelToken}) async {
    try {
      Response res = await simple!.download(url, savePath,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          options: Options(responseType: ResponseType.bytes));
      return res.data;
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  static Future upload(File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    Response res = await api!.post(
      "/info",
      data: formData,
    );
    return res.data;
  }
}

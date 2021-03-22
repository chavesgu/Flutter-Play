import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_play/service/service.dart';

class GlobalModel extends ChangeNotifier {
  GlobalModel({
    Locale? locale,
    Orientation? orientation,
  }) {
    changeLocale(
        locale ?? Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'));
    changeOrientation(orientation ?? Orientation.portrait);
  }
  Locale? get lang => _lang;
  Locale? _lang;
  void changeLocale(Locale locale) async {
    await S.load(locale);
    _lang = locale;
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(
        "locale",
        jsonEncode({
          "languageCode": locale.languageCode,
          "scriptCode": locale.scriptCode,
        }));
    notifyListeners();
  }

  bool get isFullScreen => _orientation == Orientation.landscape;
  Orientation get orientation => _orientation;
  Orientation _orientation = Orientation.portrait;
  void changeOrientation(Orientation o) {
    bool needChange = _orientation != o;
    if (needChange) {
      _orientation = o;
      notifyListeners();
    }
  }

  List get data73 => _data73;
  List _data73 = [];

  void get73Data() async {
    if (_data73.isNotEmpty) return;
    try {
      _data73 = await Service.getHuoLi73Data();
    } on DioError catch (e) {
      _data73 = [];
    }
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

class GetLocale extends Translations {
  @override
  Map<String, Map<String, String>> get keys => _keyMap;

  static Map<String, Map<String, String>> _keyMap = {
    'zh_CN': {
      'userCenter': '个人中心',
    },
    'en': {
      'userCenter': 'user center',
    }
  };

  static List<Locale> get supportedLocales {
    return _keyMap.keys.map((String str) {
      if (str.contains('_')) {
        return Locale(str.split('_').first, str.split('_')[1]);
      }
      return Locale(str);
    }).toList();
  }

  static List<LocalizationsDelegate<dynamic>> get delegate => [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static Locale defaultLocale = Locale('en');
}

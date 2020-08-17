import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../variable.dart';

class ThemeModel extends ChangeNotifier {
  ThemeModel({
    bool useSystemMode,
    ThemeMode themeMode,
    ThemeMode systemThemeMode,
  }) {
    _useSystemMode = useSystemMode;
    _appThemeMode = themeMode;
    _systemThemeMode = systemThemeMode;
  }
  // 综合主题模式
  // 当前使用模式是否暗模式
  bool get isDark => _useSystemMode?_systemThemeMode==ThemeMode.dark:_appThemeMode==ThemeMode.dark;
  // 当前的brightness
  Brightness get brightness => isDark?Brightness.dark:Brightness.light;

  // 是否使用手机系统主题
  bool _useSystemMode = false;
  bool get useSystemMode => _useSystemMode;
  void toggleUseSystemMode(bool isUse) async {
    _useSystemMode = isUse;
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('useSystemMode', isUse);
    notifyListeners();
  }

  // app内部主题模式
  ThemeMode _appThemeMode = ThemeMode.light;
  ThemeMode get appThemeMode => _appThemeMode;
  void toggleAppThemeMode(ThemeMode mode) async {
    _appThemeMode = mode;
    int index = themeModeList.indexOf(mode);
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt('appThemeMode', index);
    notifyListeners();
  }

  // app系统主题模式
  ThemeMode _systemThemeMode = ThemeMode.light;
  ThemeMode get systemThemeMode => _systemThemeMode;
  void toggleSystemThemeMode(ThemeMode mode) async {
    _systemThemeMode = mode;
    notifyListeners();
  }

  // 主题颜色索引
  int _themeIndex;
  int get themeIndex => _themeIndex;
  // 改变主题颜色索引
  void changeTheme(int index) async {
    _themeIndex = index;
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt('themeIndex', index);
    notifyListeners();
  }
}
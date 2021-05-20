import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../variable.dart';

class ThemeModel extends GetxController {
  ThemeModel({
    required bool useSystemMode,
    required ThemeMode themeMode,
    required int themeIndex,
  }) {
    _useSystemMode = useSystemMode;
    _appThemeMode = themeMode;
    _themeIndex = themeIndex;
  }
  // 综合主题模式
  // 当前使用模式是否暗模式
  bool get isDark =>
      _useSystemMode ? isSystemDark : _appThemeMode == ThemeMode.dark;
  // 当前的brightness
  Brightness get brightness => isDark ? Brightness.dark : Brightness.light;

  // 是否使用手机系统主题
  bool _useSystemMode = false;
  bool get useSystemMode => _useSystemMode;
  void toggleUseSystemMode(bool isUse) async {
    _useSystemMode = isUse;
    GetStorage storage = GetStorage();
    await storage.write('useSystemMode', isUse);
    update();
  }

  // app内部主题模式
  ThemeMode _appThemeMode = ThemeMode.light;
  ThemeMode get appThemeMode => _appThemeMode;
  void toggleAppThemeMode(ThemeMode mode) async {
    _appThemeMode = mode;
    int index = themeModeList.indexOf(mode);
    GetStorage storage = GetStorage();
    await storage.write('appThemeMode', index);
    update();
  }

  // 主题颜色索引
  int? _themeIndex;
  int? get themeIndex => _themeIndex;
  // 改变主题颜色索引
  void changeTheme(int index) async {
    _themeIndex = index;
    GetStorage storage = GetStorage();
    await storage.write('themeIndex', index);
    update();
  }
}

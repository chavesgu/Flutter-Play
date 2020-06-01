import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyBrightness extends StatelessWidget {
  MyBrightness({
    @required this.brightness,
    @required this.child,
  });

  final Brightness brightness;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final SystemUiOverlayStyle style = SystemUiOverlayStyle(
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness==Brightness.light?Brightness.dark:Brightness.light,
      statusBarColor: Colors.transparent,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: child,
    );
  }
}
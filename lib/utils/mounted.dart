import 'package:flutter/material.dart';
//import 'package:page_life_cycle/page_life_cycle.dart';

mixin MountedMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
      .addPostFrameCallback((_) => afterMounted(context));
  }

//  @mustCallSuper
  void afterMounted(BuildContext context) {
//    bool isDark = Provider.of<GlobalModel>(context).isDark;
//    StatusbarUtil.setStatusBarFont(isDark?FontStyle.white:FontStyle.black);
  }
}
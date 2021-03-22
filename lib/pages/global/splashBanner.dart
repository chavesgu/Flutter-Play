import 'dart:async';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/router/path.dart';
import 'package:provider/provider.dart';

import 'package:flutter_play/router/router.dart';
import 'package:flutter_play/components/GlobalComponents.dart';
import 'package:flutter_play/variable.dart';
import 'package:flutter_play/store/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashBanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashBannerState();
  }
}

class SplashBannerState extends State<SplashBanner> {
  Timer? _timer;
  int count = 3;

  @override
  Widget build(BuildContext context) {
    return MyBrightness(
      brightness: context.watch<ThemeModel>().brightness,
      child: Container(
        width: vw,
        height: vh,
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(
                '启动广告',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Positioned(
              bottom: height(200),
              right: width(60),
              child: GestureDetector(
                child: Text(
                  '跳过 ${count.toString()}',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onTap: _goEntry,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    if (_timer != null) _timer!.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        count--;
        if (count < 1) {
          _goEntry();
        }
      });
    });
    super.initState();
  }

  _goEntry() async {
    if (_timer != null) _timer!.cancel();
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool("splash", true);
    RouterManager.router!.navigateTo(context, EntryPage.name,
        clearStack: true,
        transitionDuration: Duration(milliseconds: 500),
        transition: TransitionType.fadeIn);
  }
}

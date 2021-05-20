import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/router/path.dart';
import 'package:flutter_play/variable.dart';
import 'package:flutter_orientation/flutter_orientation.dart';
import 'package:get/get.dart';
import 'package:move_bg/move_bg.dart';

import 'media/media.dart';
import 'user/userCenter.dart';
import 'demo/demo.dart';

import '../components/MyBottomNav.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class EntryPage extends StatefulWidget {
  static const name = '/app';

  @override
  createState() => EntryPageState();
}

class EntryPageState extends State<EntryPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static GlobalKey<InnerDrawerState> drawerKey = GlobalKey<InnerDrawerState>();

  List<Map<String, dynamic>> _pages = [
    {
      "title": DemoPage.title,
      "icon": DemoPage.icon,
      "instance": DemoPage(drawerKey: drawerKey),
    },
    {
      "title": MediaPage.title,
      "icon": MediaPage.icon,
      "instance": MediaPage(),
    },
    {
      "title": UserCenter.title,
      "icon": UserCenter.icon,
      "instance": UserCenter(),
    },
  ];
  int _tab = 0;
  PageController tabController = PageController();

  bool get isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  Widget build(BuildContext context) {
    //
    uiInit(context);
    //
    Widget _drawer = Container(
      padding: EdgeInsets.only(
        top: statusBarHeight + width(40),
        left: width(30),
        right: width(30),
        bottom: width(40),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          _renderDrawerItem(
            text: '设置',
            onTap: () {
              Get.toNamed(SettingPage.name);
            },
          ),
          _renderDrawerItem(
            text: '关于我们',
            onTap: () {
              Get.toNamed(
                  '${MyWebView.name}?url=${Uri.encodeQueryComponent('https://www.chavesgu.com')}');
            },
          ),
        ],
      ),
    );
    return WillPopScope(
      onWillPop: () async {
        bool canPop = navigator!.canPop();
        if (canPop) return true;
        if (Platform.isAndroid) {
          MoveBg.run();
        }
        return false;
      },
      child: InnerDrawer(
        key: drawerKey,
        onTapClose: true,
        swipe: !isFullScreen,
        leftChild: _drawer,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        scaffold: Scaffold(
          body: PageView(
            controller: tabController,
            onPageChanged: _pageChange,
            children: _pages.map<Widget>((e) => e["instance"]).toList(),
            physics: NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: Offstage(
            offstage:
                MediaQuery.of(context).orientation == Orientation.landscape,
            child: StatefulBuilder(
              builder: (context, stateSetter) {
                return MyBottomNav(
                  onChange: toggleTab,
                  currentIndex: _tab,
                  iconSize: width(46),
                  items: <MyBottomNavItem>[
                    for (var page in _pages)
                      MyBottomNavItem(
                        icon: page["icon"],
                        title: page["title"],
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderDrawerItem({required String text, Function? onTap}) {
    return GestureDetector(
      child: Container(
        height: width(100),
        margin: EdgeInsets.only(bottom: width(40)),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: width(30),
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        if (onTap != null) onTap();
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        print('前台');
        if (MediaQuery.of(context).orientation == Orientation.portrait) {
          FlutterOrientation.setOrientation(DeviceOrientation.portraitUp);
        } // 每次进入前台时锁定当前方向
        if (MediaQuery.of(context).orientation == Orientation.landscape) {
          FlutterOrientation.setOrientation(DeviceOrientation.landscapeRight);
        }
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        print('后台');
        break;
      case AppLifecycleState.detached: // 申请将暂时暂停
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  void toggleTab(int value) async {
    tabController.jumpToPage(value);
    HapticFeedback.heavyImpact();
  }

  void _pageChange(int value) {
    setState(() {
      _tab = value;
    });
  }
}

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/routerPath.dart';
import 'package:flutter_play/variable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orientation/orientation.dart';
import 'package:move_bg/move_bg.dart';
import 'package:provider/provider.dart';

import 'media/media.dart';
import 'home/home.dart';
import 'user/userCenter.dart';
import 'demo/demo.dart';

import '../components/MyBottomNav.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class EntryPage extends StatefulWidget {
  static const name = '/app';

  @override
  createState() => EntryPageState();
}

class EntryPageState extends State<EntryPage> with WidgetsBindingObserver {
  static GlobalKey<InnerDrawerState> drawerKey = GlobalKey<InnerDrawerState>();

  List<Widget> _pages = [
    DemoPage(),
    HomePage(drawerKey: drawerKey),
    MediaPage(),
    UserCenter(),
  ];
  int _tab = 0;

  final PageController tabController = PageController();

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    ScreenUtil.init(context, width: 750, height: 1334);
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
              Navigator.of(context).pushNamed(SettingPage.name);
            }
          ),
          _renderDrawerItem(
            text: '关于我们',
            onTap: () {
              Navigator.of(context).pushNamed('${AboutPage.name}?url=${Uri.encodeQueryComponent('https://www.chavesgu.com')}');
            }
          ),
        ],
      ),
    );

    return WillPopScope(
      child: InnerDrawer(
        key: drawerKey,
        onTapClose: true,
        swipe: false,
        leftChild: _drawer,
        backgroundColor: Theme.of(context).primaryColor,
        scaffold: Scaffold(
          body: PageView(
            controller: tabController,
            children: _pages,
            onPageChanged: _pageChange,
            physics: NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: Offstage(
            offstage: MediaQuery.of(context).orientation == Orientation.landscape,
            child: MyBottomNav(
              onTap: toggleTab,
              currentIndex: _tab,
              iconSize: width(46),
              items: <MyBottomNavItem>[
                MyBottomNavItem(
                  icon: Icon(Icons.build,),
                  title: 'demo'
                ),
                MyBottomNavItem(
                  icon: Icon(Icons.home),
                  title: 'home'
                ),
                MyBottomNavItem(
                  icon: Icon(Icons.subscriptions,),
                  title: 'media'
                ),
                MyBottomNavItem(
                  icon: Icon(Icons.people,),
                  title: 'user'
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: _willPop,
    );
  }

  Widget _renderDrawerItem({ String text, Function onTap }) {
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
                fontWeight: FontWeight.normal
              ),
            )
          ],
        ),
      ),
      onTap: () {
        if (onTap!=null) onTap();
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed:// 应用程序可见，前台
        print('前台');
        if (MediaQuery.of(context).orientation == Orientation.portrait) {
          OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
        } // 每次进入前台时锁定当前方向
        if (MediaQuery.of(context).orientation == Orientation.landscape) {
          OrientationPlugin.forceOrientation(DeviceOrientation.landscapeRight);
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
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void toggleTab(int value)async {
    tabController.jumpToPage(value);
    HapticFeedback.heavyImpact();
  }

  void _pageChange(int value) {
    setState(() {
      _tab = value;
    });
  }

  Future<bool> _willPop() async {
//    if (Navigator.canPop(context)) {
//      return true;
//    } else {
//    }
    if(Platform.isAndroid) {
      MoveBg.moveToBackground();
    }
    return false;
  }
}
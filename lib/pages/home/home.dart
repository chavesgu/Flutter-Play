import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart' show InnerDrawerState;
import 'package:flutter_play/pages/home/scan.dart';
import 'package:flutter_play/pages/home/search.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_play/service.dart';
import 'package:flutter_play/variable.dart';
import 'package:flutter_play/components/GlobalComponents.dart';
import 'homeComponent.dart' as Home;

class HomePage extends StatefulWidget {
  HomePage({ this.drawerKey });

  final GlobalKey<InnerDrawerState> drawerKey;

  @override
  createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  bool _hideInputClear = true;
  FocusNode _focusNode;
  final _inputController = MyTextEditingController();
  String get query => _inputController.text;
  set query(String value) {
    assert(query != null);
    _inputController.text = value;
  }

  final _refreshController = RefreshController();
  final _scrollController = ScrollController();
  bool _hideGoTop = true;
  double _goTopOpacity = 0;


  // data
  List<dynamic> bannerList = [];
  List<dynamic> recommendMusicList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(const IconData(0xe610, fontFamily: 'iconfont')),
              onPressed: (){
                _focusNode?.unfocus();
                goScan();
              },
            )
          ],
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _focusNode?.unfocus();
                  if (widget.drawerKey!=null) widget.drawerKey.currentState.open();
                },
              );
            },
          ),
          title: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(36)),
            child: Container(
              height: 36,
              child: TextField(
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: width(30),
                  textBaseline: TextBaseline.alphabetic,
                  color: Colors.black
                ),
                focusNode: _focusNode,
                controller: _inputController,
                cursorColor: Theme.of(context).primaryColor,
                textInputAction: TextInputAction.search,
                onSubmitted: _submit,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '请输入关键词搜索',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: width(30),
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    size: width(48),
                  ),
                  suffixIcon: Offstage(
                    offstage: _hideInputClear,
                    child: GestureDetector(
                      onTap: _clearInput,
                      child: Icon(
                        Icons.close,
                        size: width(48),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          _focusNode?.unfocus();
        },
        child: Stack(
          children: <Widget>[
            CupertinoScrollbar(
              child: SmartRefresher(
                header: ClassicHeader(
                  idleText: '下拉刷新数据',
                  releaseText: '释放刷新',
                  refreshingText: '刷新中',
                  completeText: '刷新数据成功',
                  failedText: '刷新数据失败',
                ),
                footer: ClassicFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  idleText: '上拉加载',
                  loadingText: '加载中',
                  canLoadingText: '松开加载更多',
                  noDataText: '没有更多数据',
                  failedText: '加载失败，点击重试',
                ),
                controller: _refreshController,
                onRefresh: _refresh,
                onLoading: _loadMore,
                enablePullDown: true,
                enablePullUp: true,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  children: <Widget>[
                    Home.Banner(bannerList),
                    Home.Tag(),
                    Home.RecommendMusicList(recommendMusicList),
                  ],
                ),
              ),
            ),
            Positioned(
              child: Offstage(
                offstage: _hideGoTop,
                child: AnimatedOpacity(
                  opacity: _goTopOpacity,
                  duration: Duration(milliseconds: 600),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.arrow_upward, color: Colors.white),
                        onPressed: _goTop,
                      ),
                    ),
                  ),
                ),
              ),
              bottom: 10,
              right: 10,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _focusNode = FocusNode(debugLabel: "search");
    _refresh();
    _inputController.addListener(_inputChange);
    _scrollController.addListener(_scrollListen);
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _refreshController.dispose();
    _inputController.removeListener(_inputChange);
    _scrollController.removeListener(_scrollListen);
    super.dispose();
  }

  void _refresh() async {
    try {
      // banner
      bannerList = await Service.getHomeBanner();
      recommendMusicList = await Service.getRecommendMusicList();
      setState(() {
        _refreshController.refreshCompleted();
      });
    } on DioError catch(e) {
      setState(() {
        _refreshController.refreshFailed();
      });
    }
  }

  void _loadMore() async {
//    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _refreshController.loadComplete();
//      _refreshController.loadFailed();
//      _refreshController.loadNoData();
    });
  }

  void _submit(value) {
    Navigator.of(context).pushNamed('${SearchPage.name}?text=${Uri.encodeQueryComponent(value)}',);
  }

  void _inputChange() {
    if (query.length > 0) {
      if (_hideInputClear) {
        setState(() {
          _hideInputClear = false;
        });
      }
    } else {
      if (!_hideInputClear) {
        setState(() {
          _hideInputClear = true;
        });
      }
    }
  }

  void _clearInput() {
    setState(() {
      query = '';
      _hideInputClear = true;
    });
  }

  void _scrollListen() {
    if (_scrollController.offset > 200) {
      if (_hideGoTop) {
        setState(() {
          _hideGoTop = false;
          _goTopOpacity = 1;
        });
      }
    } else {
      if (!_hideGoTop) {
        setState(() {
          _goTopOpacity = 0;
          _hideGoTop = true;
        });
      }
    }
  }

  void _goTop() {
    _scrollController.animateTo(0, duration: Duration(milliseconds: 600), curve: Curves.linear);
  }

  void goScan() async {
    PermissionStatus permissionStatus = (await Permission.camera.status);
    bool hasPermission = permissionStatus==PermissionStatus.granted;
    bool unknown = (permissionStatus.isUndetermined) || (permissionStatus.isDenied);
    if (unknown) {
      hasPermission = await Permission.camera.request().isGranted;
    }
    if (hasPermission) {
      Navigator.of(context).pushNamed(ScanPage.name);
    } else{
      showAlert(
        context: context,
        barrierDismissible: false,
        title: '扫码提示',
        body: '扫码需要允许相机权限',
        actions: [
          AlertAction(
            text: '取消',
            onPressed: () {
            },
          ),
          AlertAction(
            text: '前往设置',
            onPressed: () {
              openAppSettings();
            },
          )
        ],
      );
    }
  }
}

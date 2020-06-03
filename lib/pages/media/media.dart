import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:flutter_play/variable.dart';
import 'package:flutter_play/components/GlobalComponents.dart';

class MediaPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MediaPageState();
  }
}

class MediaPageState extends State<MediaPage> with AutomaticKeepAliveClientMixin {

  Key _refreshKey = Key('smartRefresh');
  final _refreshController = RefreshController();
  String url;
  String videoTitle = '';
  bool get _isFullScreen => MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _isFullScreen?null:PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text('Media'),
        ),
      ),
      body: Container(
        child: SmartRefresher(
          key: _refreshKey,
          header: ClassicHeader(
            idleText: '下拉刷新数据',
            releaseText: '释放刷新',
            refreshingText: '刷新中',
            completeText: '刷新数据成功',
            failedText: '刷新数据失败',
          ),
          footer: ClassicFooter(
            idleText: '上拉加载',
            loadingText: '加载中',
            noDataText: '没有更多数据',
            failedText: '加载失败，点击重试',
          ),
          controller: _refreshController,
          onRefresh: _refresh,
//          onLoading: _loadMore,
          enablePullDown: !_isFullScreen,
//          enablePullUp: true,
          child: ListView(
            physics: _isFullScreen?NeverScrollableScrollPhysics():BouncingScrollPhysics(),
            children: <Widget>[
              Offstage(
                offstage: _isFullScreen,
                child: Wrap(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('示例视频'),
                      onPressed: () {
                        setState(() {
                          videoTitle = '示例视频';
                          url = 'https://cdn.chavesgu.com/SampleVideo.mp4';
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: MyVideo(
                  url: url,
                  title: videoTitle,
                  width: _isFullScreen?vh:vw,
                  height: _isFullScreen?vw:vw/16*9,
                  autoplay: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  _refresh()async {
    await Future.delayed(Duration(seconds: 2));
    _refreshController.refreshCompleted();
  }
}
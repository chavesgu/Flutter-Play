import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:flutter_play/variable.dart';
import 'package:flutter_play/components/GlobalComponents.dart';

class MediaPage extends StatefulWidget {
  static const String title = 'media';
  static const Icon icon = Icon(Icons.subscriptions);

  @override
  State<StatefulWidget> createState() {
    return MediaPageState();
  }
}

class MediaPageState extends State<MediaPage> with AutomaticKeepAliveClientMixin {

  Key _refreshKey = Key('smartRefresh');
  final _refreshController = EasyRefreshController();
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
        child: EasyRefresh(
          key: _refreshKey,
          header: ClassicalHeader(
            refreshText: '下拉刷新数据',
            refreshReadyText: '释放刷新',
            refreshingText: '刷新中',
            refreshedText: '刷新数据成功',
            refreshFailedText: '刷新数据失败',
          ),
          footer: ClassicalFooter(
            loadText: '上拉加载',
            loadingText: '加载中',
            loadedText: '加载完成',
            loadReadyText: '松开加载更多',
            noMoreText: '没有更多数据',
            loadFailedText: '加载失败，点击重试',
          ),
          controller: _refreshController,
          onRefresh: _isFullScreen?_refresh:null,
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
              MyVideo(
                url: url,
                title: videoTitle,
                width: _isFullScreen?vh:vw,
                height: _isFullScreen?vw:vw/16*9,
//                  autoplay: true,
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
    _refreshController.finishRefresh(success: true);
  }
}
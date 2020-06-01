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
  List<String> bannerList = [
    'http://trademaster-files.oss-cn-shanghai.aliyuncs.com/8aecde43-3d9a-bb67-81d3-0c703d21e07f.jpg',
    'http://trademaster-files.oss-cn-shanghai.aliyuncs.com/6153a0a8-dc90-4bfa-8e92-c328dbcb8189.jpg',
    'http://trademaster-files.oss-cn-shanghai.aliyuncs.com/f51b68c9-811d-e7db-8079-b0a86e85b4b2.jpg',
    'http://trademaster-files.oss-cn-shanghai.aliyuncs.com/205b15f0-69f7-a42b-8ed7-c43460792d0f.jpg',
  ];
  String url;
  String videoTitle = '';
  bool get _isFullScreen => MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _isFullScreen?null:AppBar(
        title: Text('Media'),
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
//              Offstage(
//                offstage: _isFullScreen,
//                child: Container(
//                  width: vw,
//                  height: vw*9/16,
//                  child: Swiper(
//                    itemBuilder: (BuildContext context,int index){
//                      return MyImage(
//                        url: bannerList[index],
//                      );
//                    },
//                    itemCount: bannerList.length,
//                    pagination: new SwiperPagination(),
//                    control: new SwiperControl(),
//                  ),
//                ),
//              ),
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
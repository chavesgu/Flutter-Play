import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/components/GlobalComponents.dart';
import 'package:flutter_play/router/path.dart';
import 'package:flutter_play/store/global.dart';
import 'package:flutter_play/variable.dart';
import 'package:get/get.dart';

class VideoDetailPage extends StatefulWidget {
  static const String name = '/video-detail';

  @override
  State<StatefulWidget> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
// https://cdn.chavesgu.com/SampleVideo.mp4
  bool get isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;
  TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Offstage(
            offstage: isFullScreen,
            child: Container(
              height: statusBarHeight,
              color: Colors.black,
            ),
          ),
          MyVideo(
            'https://cdn.chavesgu.com/SampleVideo.mp4',
            width: isFullScreen ? vh : vw,
            height: isFullScreen ? vw : vw / 16 * 9,
          ),
          Offstage(
            offstage: isFullScreen,
            child: Container(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: tabController,
                      isScrollable: true,
                      indicatorColor: Colors.red,
                      unselectedLabelColor: Colors.black54,
                      tabs: [
                        Tab(
                          text: '简介',
                        ),
                        Tab(
                          text: '评论 9999',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Offstage(
              offstage: isFullScreen,
              child: TabBarView(
                controller: tabController,
                children: [
                  KeepAliveWidget(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: width(15),
                      ),
                      children: [
                        Text(
                          'SampleVideo',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          'desc',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  KeepAliveWidget(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: width(15),
                      ),
                      itemCount: 20,
                      itemBuilder: (_, index) {
                        return Text('comment-$index');
                      },
                      separatorBuilder: (_, index) {
                        return Divider();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }
}

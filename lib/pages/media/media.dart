import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/pages/media/articleList.dart';
import 'package:flutter_play/pages/media/audioList.dart';
import 'package:flutter_play/pages/media/videoList.dart';
// import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:flutter_play/variable.dart';

class MediaPage extends StatefulWidget {
  static const String title = 'media';
  static const Icon icon = Icon(Icons.subscriptions);

  @override
  State<StatefulWidget> createState() {
    return MediaPageState();
  }
}

class MediaPageState extends State<MediaPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TabController? tabController;
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
              title: Text('Media'),
              toolbarHeight: 50,
              automaticallyImplyLeading: false,
            ),
      body: Column(
        children: [
          SizedBox(
            width: vw,
            height: 44,
            child: TabBar(
              isScrollable: true,
              controller: tabController,
              indicatorColor: Colors.red,
              tabs: [
                Tab(
                  text: '视频',
                ),
                Tab(
                  text: '音频',
                ),
                Tab(
                  text: '文章',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                VideoList(),
                AudioList(),
                ArticleList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    super.initState();
  }
}

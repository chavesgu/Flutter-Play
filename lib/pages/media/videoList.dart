import 'package:flutter/material.dart';
import 'package:flutter_play/components/GlobalComponents.dart';
import 'package:flutter_play/pages/media/videoDetail.dart';
import 'package:flutter_play/variable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VideoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  RefreshController? _refreshController;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SmartRefresher(
      header: ClassicHeader(
        height: 50,
        idleText: '下拉刷新数据',
        releaseText: '释放刷新',
        refreshingText: '刷新中',
        completeText: '刷新数据成功',
        failedText: '刷新数据失败',
      ),
      controller: _refreshController!,
      // enablePullDown: !_isFullScreen,
      onRefresh: _refresh,
      child: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              goDetail(index);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width(30), vertical: width(24)),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: width(30)),
                    child: Container(
                      width: width(160),
                      height: width(160),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(width(16))),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          MyImage(
                            'https://cdn.chavesgu.com/avatar.jpg',
                          ),
                          Container(
                            color: Colors.black.withOpacity(0.3),
                            child: Icon(
                              IconFont.play,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text('标题$index'),
                      Text('描述$index'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  void _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    _refreshController?.refreshCompleted();
  }

  void goDetail(int index) {
    Get.toNamed(VideoDetailPage.name);
  }
}

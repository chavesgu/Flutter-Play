import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_play/components/GlobalComponents.dart';
import 'package:flutter_play/service/service.dart';
import 'package:flutter_play/variable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AudioList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AudioListState();
}

class _AudioListState extends State<AudioList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  RefreshController? _refreshController;
  List music = [];

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
        cacheExtent: 2,
        itemCount: music.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              List<int> ids = music.map<int>((e) => e["id"]).toList();
              Navigator.of(context).pushNamed(
                  '/audio-detail?list=${jsonEncode(ids)}&current=$index');
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: width(30),
                vertical: width(24),
              ),
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
                            music[index]['al']['picUrl'],
                            loadingSize: width(40),
                          ),
                          Container(
                            color: Colors.black.withOpacity(0.1),
                            child: Icon(
                              IconFont.play,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          music[index]['al']['name'],
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text(
                          music[index]['ar'][0]['name'],
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
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
    _refreshController = RefreshController(initialRefresh: true);
    super.initState();
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  void _refresh() async {
    music = await Service.getHotMusic().catchError((e) {});
    _refreshController?.refreshCompleted();
    setState(() {});
  }
}

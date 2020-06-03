import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_play/components/GlobalComponents.dart';
import 'package:flutter_play/service.dart';
import 'package:flutter_play/variable.dart';

class TopListPage extends StatefulWidget {
  static const name = '/topList';

  @override
  State<StatefulWidget> createState()=>TopListPageState();
}

class TopListPageState extends State<TopListPage> {
  List<dynamic> list = [];

  List<dynamic> tracksList = [];

  List<dynamic> noTracksList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text('排行榜'),
        ),
      ),
      body: CupertinoScrollbar(
        child: ListView(
          padding: EdgeInsets.only(
            left: width(30),
            right: width(30),
          ),
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            ..._renderTracksData(),
            Container(
              margin: EdgeInsets.only(top: width(40)),
              child: Wrap(
                spacing: width(30),
                runSpacing: width(30),
                children: _renderNoTracks(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getTopListData();
  }

  _getTopListData() async {
    list = await Service.getTopList();
    list.sort((a, b) => b["tracks"].length.compareTo(a["tracks"].length));
    list.forEach((item) {
      if (item["tracks"].length>0) {
        tracksList.add(item);
      } else {
        noTracksList.add(item);
      }
    });
    setState(() {

    });
  }

  List<Widget> _renderTracksData() {
    List<Widget> res = [];
    for (int i = 0;i < tracksList.length;i++) {
      res.add(Container(
        margin: EdgeInsets.only(top: width(20)),
        child: Row(
          children: <Widget>[
            Container(
              width: width(210),
              height: width(210),
              margin: EdgeInsets.only(right: width(25)),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    child: MyImage(
                      list[i]["coverImgUrl"],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(width(10))),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 5,
                    child: Text(
                      list[i]["updateFrequency"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width(24)
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _renderTracksItem(list[i]["tracks"]),
              ),
            ),
          ],
        ),
      ));
    }
    return res;
  }

  List<Widget> _renderTracksItem(List tracks) {
    List<Widget> res = [];
    for (int i = 0;i < tracks.length;i++) {
      res.add(Text(
        "${i+1}. ${tracks[i]["first"]} - ${tracks[i]["second"]}",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          height: 1.8,
        ),
      ));
    }
    return res;
  }

  List<Widget> _renderNoTracks() {
    List<Widget> res = [];
    for (int i = 0;i < noTracksList.length;i++) {
      res.add(Container(
        width: width(210),
//        height: width(205),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  child: MyImage(
                    noTracksList[i]["coverImgUrl"],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(width(10))),
                ),
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: Text(
                    noTracksList[i]["updateFrequency"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width(24)
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: width(20)),
              child: Text(
                noTracksList[i]["name"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }
    return res;
  }
}
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/components/GlobalComponents.dart';
import 'package:flutter_play/service.dart';
import 'package:flutter_play/variable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MusicListDetailPage extends StatefulWidget {
  static const name = "/musicListDetail";

  MusicListDetailPage(this.id);

  final String id;

  @override
  State<StatefulWidget> createState() {
    return MusicListDetailPageState();
  }
}

class MusicListDetailPageState extends State<MusicListDetailPage> {
  get id => widget.id;

  Map<String, dynamic> detail;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          elevation: 0,
          brightness: Brightness.dark,
          textTheme: TextTheme(
            bodyText1: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white,
            ),
            button: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
        )
      ),
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          title: Text("歌单"),
        ),
        extendBodyBehindAppBar: true,
        body: detail!=null?
        Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            MyImage(
              detail["coverImgUrl"],
              fit: BoxFit.cover,
              width: vw,
              height: vh,
            ),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20,
                  sigmaY: 20,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  width: vw,
                  height: vh,
                ),
              ),
            ),
            CupertinoScrollbar(
              child: ListView(
                padding: EdgeInsets.only(top: statusBarHeight + kToolbarHeight),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: width(50)),
                    padding: EdgeInsets.only(
                      left: width(30),
                      right: width(30),
                    ),
                    height: width(250),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: width(30)),
                          width: width(250),
                          height: width(250),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(width(16))),
                            child: Stack(
                              children: <Widget>[
                                MyImage(
                                  detail["coverImgUrl"],
                                  loadingSize: width(50),
                                ),
                                Positioned(
                                  right: 5,
                                  top: 2,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.white,
                                        size: width(30),
                                      ),
                                      Text(
                                        calcCount(detail["playCount"]),
                                        style: TextStyle(
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black,
                                              blurRadius: 2,
                                            )
                                          ]
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                detail["name"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: width(34),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: width(10)),
                                    child: Stack(
                                      children: <Widget>[
                                        MyImage(
                                          detail["creator"]["avatarUrl"],
                                          width: width(50),
                                          height: width(50),
                                          shape: BoxShape.circle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    detail["creator"]["nickname"],
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: width(28),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white70,
                                    size: width(30),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      getDesc(detail["description"]),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: width(26),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white70,
                                    size: width(30),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ):Container(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData(id);
  }

  void getData(String id) async {
    print(id);
    detail = await Service.getMusicListDetail(id);
    setState(() {

    });
  }

  String calcCount(int count) {
    if (count > 10000) return "${(count/10000).floor()}万";
    return "$count";
  }

  String getDesc(String desc) {
    return desc.replaceAll(RegExp(r"\n"), " ");
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_play/components/GlobalComponents.dart' show MyImage;
import 'package:flutter_play/pages/global/musicListDetail.dart';
import 'package:flutter_play/variable.dart';


class RecommendMusicList extends StatelessWidget {
  RecommendMusicList(this.list);

  final List list;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(
        top: width(50),
      ),
      padding: EdgeInsets.only(
        top: width(50),
        bottom: width(50),
        left: width(30),
        right: width(30),
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xfff2f2f2)
          )
        )
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '推荐歌单',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width(36),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: width(40)),
            child: Wrap(
              spacing: width(30),
              runSpacing: width(40),
              children: _renderContent(context, list),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _renderContent(BuildContext context, List list) {
    List<Widget> res = [];
    for (int i = 0;i < list.length;i++) {
      res.add(GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed("${MusicListDetailPage.name}?id=${list[i]["id"]}");
        },
        child: Container(
          width: width(210),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(width(10))),
                    child: MyImage(
                      list[i]["picUrl"],
                      loadingSize: width(50),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: width(30),
                        ),
                        Text(
                          "${calcCount(list[i]["playCount"])}",
                          style: TextStyle(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2,
                              )
                            ]
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: width(20)),
                child: Text(
                  list[i]["name"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
//                textAlign: TextAlign.justify,
                  style: TextStyle(
                    height: 1.2
                  ),
                ),
              )
            ],
          ),
        ),
      ));
    }

    return res;
  }

  String calcCount(int count) {
    if (count > 10000) return "${(count/10000).floor()}万";
    return "$count";
  }
}
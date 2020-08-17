import 'package:flutter/material.dart';
import 'package:flutter_play/variable.dart';

import 'package:flutter_play/routerPath.dart';

class Tag extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(
        left: width(30),
        right: width(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _renderColumn(
            context: context,
            icon: Icon(
              const IconData(0xe667, fontFamily: 'iconfont'),
              size: width(40),
            ),
            title: '每日推荐',
          ),
          _renderColumn(
            context: context,
            icon: Icon(
              const IconData(0xe619, fontFamily: 'iconfont'),
              size: width(40),
            ),
            title: '歌单',
          ),
          _renderColumn(
            context: context,
            icon: Icon(
              const IconData(0xe609, fontFamily: 'iconfont'),
              size: width(40),
            ),
            title: '排行榜',
            path: TopListPage.name
          ),
          _renderColumn(
            context: context,
            icon: Icon(
              const IconData(0xe603, fontFamily: 'iconfont'),
              size: width(40),
            ),
            title: '电台',
          ),
          _renderColumn(
            context: context,
            icon: Icon(
              const IconData(0xe614, fontFamily: 'iconfont'),
              size: width(40),
            ),
            title: '直播',
          ),
        ],
      ),
    );
  }

  Widget _renderColumn({ BuildContext context, Icon icon, String title, String path }) {
    return GestureDetector(
      onTap: () {
        if (path!=null) Navigator.of(context).pushNamed(path);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: width(80),
            height: width(80),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context!=null?Theme.of(context).primaryColor:Colors.red,
            ),
            child: Center(
              child: icon??null,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: width(20)),
            child: Text(
              title??'',
              style: TextStyle(
                fontSize: width(26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
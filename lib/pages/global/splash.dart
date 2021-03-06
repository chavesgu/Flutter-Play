import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_play/variable.dart';
import '../entry.dart';


class Splash extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 750, height: 1334);
    return Container(
      width: vw,
      height: vh,
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: <Widget>[
          PageView(
            physics: ClampingScrollPhysics(),
            onPageChanged: _pageChange,
            children: <Widget>[
              Center(
                child: Text(
                  '引导页一',
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '引导页二',
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '引导页三',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  OutlineButton(
                    onPressed: _goEntry,
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    child: Text('立即体验'),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            width: vw,
            left: 0,
            bottom: bottomAreaHeight + 100,
            child: Row(
              children: _renderIndicator(),
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          )
        ],
      ),
    );
  }

  void _pageChange(int index) {
    setState(() {
      current = index;
    });
  }

  List<Widget> _renderIndicator() {
    List<Widget> res = [];
    for (var i=0;i<3;i++) {
      res.add(Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: i==current?Colors.black:Colors.white,
        ),
        width: 10,
        height: 10,
        margin: EdgeInsets.only(left: 5,right: 5),
      ));
    }
    return res;
  }

  _goEntry() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
          return FadeTransition(
            opacity: animation,
            child: EntryPage(),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }
}
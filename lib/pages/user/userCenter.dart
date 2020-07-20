import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_play/store/model.dart';
import 'package:flutter_play/components/GlobalComponents.dart';
import 'package:flutter_play/pages/global/imagePreview.dart';
import 'package:flutter_play/variable.dart';

class UserCenter extends StatefulWidget {
  @override
  createState() => UserCenterState();
}

class UserCenterState extends State<UserCenter> with AutomaticKeepAliveClientMixin,WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('个人中心'),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Column(
              children: <Widget>[
                GestureDetector(
                  onTapUp: (TapUpDetails details) {
                    _scale('https://cdn.chavesgu.com/avatar.jpg', details);
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    child: ClipOval(
                      child: MyImage(
                        'https://cdn.chavesgu.com/avatar.jpg',
                      ),
                    ),
                  ),
                ),
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_)=>UserModel())
                  ],
                  child: Consumer<UserModel>(
                    builder: (context, model, child) {
                      return Text(model.title);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _scale(String url, TapUpDetails details) {
    double _x = (vw/2 - details.globalPosition.dx)/(vw/2);
    double _y = (vh/2 - details.globalPosition.dy)/(vh/2);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
          return ScaleTransition(
            scale: animation,
            alignment: Alignment(
              -_x,
              -_y
            ),
            child: ImagePreview(
              imageList: [url, url],
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 150),
      )
    );
  }
}
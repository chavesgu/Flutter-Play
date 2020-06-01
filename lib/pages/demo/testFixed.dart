import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestFixedPage extends StatelessWidget {
  static const name = '/testFixed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: _renderList(),
              ),
            ),
            Container(
              height: ScreenUtil().setWidth(50),
              child: TextField(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _renderList() {
    List<Widget> list = [];
    for (int i = 0;i<20;i++) {
      list.add(Container(
        child: Text('item-$i'),
        height: ScreenUtil().setWidth(100),
      ));
    }
    return list;
  }
}
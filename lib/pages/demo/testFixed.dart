import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestFixedPage extends StatelessWidget {
  static const name = '/testFixed';

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('test animate to'),
              onPressed: () {
                animateTo();
              },
            ),
            Expanded(
              child: ListView(
                children: _renderList(),
                controller: controller,
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

  void animateTo() {
    controller.animateTo(
      100,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
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
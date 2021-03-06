import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../variable.dart';

class TestFixedPage extends StatelessWidget {
  static const name = '/testFixed';

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test fixed'),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('test animate to end'),
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
              height: width(50),
              child: TextField(),
            ),
          ],
        ),
      ),
    );
  }

  void animateTo() {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
  }

  List<Widget> _renderList() {
    List<Widget> list = [];
    for (int i = 0;i<20;i++) {
      list.add(Container(
        child: Text('item-$i'),
        height: width(100),
      ));
    }
    return list;
  }
}
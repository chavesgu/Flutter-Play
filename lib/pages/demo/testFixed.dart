import 'package:flutter/material.dart';
import 'package:flutter_play/router/path.dart';
import 'package:flutter_play/utils/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

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
            ElevatedButton(
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
    for (int i = 0; i < 20; i++) {
      list.add(Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigoAccent,
              foregroundColor: Colors.white,
            ),
            title: Text('line is ${i + 1}'),
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              Toast.show("delete ${i + 1}");
            },
          ),
        ],
      ));
    }
    return list;
  }
}

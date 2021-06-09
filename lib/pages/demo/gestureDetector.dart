import 'package:flutter/material.dart';
import 'package:flutter_play/components/GlobalComponents.dart';

class GestureDetectorDemo extends StatefulWidget {
  static const String name = '/gestureDetectorDemo';
  @override
  State<StatefulWidget> createState() => GestureDetectorDemoState();
}

class GestureDetectorDemoState extends State<GestureDetectorDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text('GestureDetectorDemo'),
      ),
      body: CssBox(),
    );
  }
}

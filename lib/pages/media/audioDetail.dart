import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioDetailPage extends StatefulWidget {
  static const String name = '/audio-detail';

  AudioDetailPage();

  @override
  State<StatefulWidget> createState() => _AudioDetailState();
}

class _AudioDetailState extends State<AudioDetailPage> {
  List get list => Get.arguments['list'];
  int? index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('$index'),
    );
  }

  @override
  void initState() {
    index = Get.arguments['current'] ?? 0;
    super.initState();
  }
}

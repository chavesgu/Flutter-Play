import 'package:flutter/material.dart';

class AudioDetailPage extends StatefulWidget {
  static const String name = '/audio-detail';

  AudioDetailPage(
    this.list, {
    this.current = 0,
  });

  final int current;
  final List list;

  @override
  State<StatefulWidget> createState() => _AudioDetailState();
}

class _AudioDetailState extends State<AudioDetailPage> {
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
    index = widget.current;
    super.initState();
  }
}

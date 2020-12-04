import 'dart:typed_data';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../../variable.dart';

class TestOCR extends StatefulWidget {
  static const name = '/testOcr';

  @override
  State<StatefulWidget> createState() => TestOCRState();
}

class TestOCRState extends State<TestOCR> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text('test gesture'),
        ),
      ),
      body: Container(
        width: vw,
        height: vh,
        child: Stack(
          children: [
            GestureDetector(
              child: Container(
                child: Text('笑了'),
                width: 80,
                height: 40,
                color: Colors.red,
              ),
              onTap: () {
                print('smile');
              },
            ),
            Positioned(
              child: IgnorePointer(
                child: Container(
                  width: vw,
                  height: 200,
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}
import 'dart:typed_data';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class TestOCR extends StatefulWidget {
  static const name = '/testOcr';

  @override
  State<StatefulWidget> createState() => TestOCRState();
}

class TestOCRState extends State<TestOCR> {
  dynamic _scanResults;
  CameraController _camera;

  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;

  Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text('test ocr'),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            child: _camera!=null?AspectRatio(
              aspectRatio: _camera.value.aspectRatio,
              child: CameraPreview(_camera),
            ):Container(),
          ),
          RaisedButton(
            child: Text('test ocr'),
            onPressed: () {
              _testOCR();
            },
          ),
          Container(
            height: 100,
            child: bytes!=null?Image(image: MemoryImage(bytes),):Container(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _camera?.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeCamera();
  }

  _testOCR() async {
    if (_camera==null) return;
    _camera.startImageStream((CameraImage image) {
      try {
        // await doSomethingWith(image)
//        List<Plane> res = image.planes;
//        bytes = res.first.bytes;
        setState(() {

        });
      } catch (e) {
        // await handleExepction(e)
      } finally {
      }
    });
  }

  void _initializeCamera() async {
    _camera = CameraController(
      await _getCamera(_direction),
      ResolutionPreset.veryHigh,
    );
    await _camera.initialize();
  }

  // 获取所选择前置/后置可用的相机
  Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return await availableCameras().then((List<CameraDescription> cameras) {
      List res = cameras.where((CameraDescription camera) => camera.lensDirection == dir).toList();
      return res.first;
    });
  }
}
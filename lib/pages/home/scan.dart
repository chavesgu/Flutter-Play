import 'package:flutter/material.dart';
import 'package:qrcode/qrcode.dart';
import 'package:flutter_play/variable.dart';

class ScanPage extends StatefulWidget {
  static const name = '/scan';
  @override
  createState()=>_ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  QRCaptureController _captureController = QRCaptureController();
  String _scanData = '';
  bool _isFlashOn = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('扫一扫'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isFlashOn?Icons.flash_off:Icons.flash_on),
            onPressed: (){
              setState(() {
                if (_isFlashOn) {
                  _captureController.torchMode = CaptureTorchMode.off;
                } else {
                  _captureController.torchMode = CaptureTorchMode.on;
                }
                _isFlashOn = !_isFlashOn;
              });
            },
          )
        ]
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: height(800),
                child: QRCaptureView(controller: _captureController),
              ),
              Positioned(
                child: Center(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: Container(
                    height: width(500),
                    width: width(500),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2)
                    ),
                  ),
                ),
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
              )
            ],
          ),
          Text(_scanData)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _captureController.onCapture((data) {
      setState(() {
        _scanData = data;
      });
      print('onCapture----$data');
    });
  }
}
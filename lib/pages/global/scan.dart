import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:images_picker/images_picker.dart';
import 'package:scan/scan.dart';
import 'package:flutter_play/variable.dart';
import 'package:flutter_play/utils/utils.dart';

class ScanPage extends StatefulWidget {
  static const name = '/scan';
  @override
  createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ScanController scanController = ScanController();
  bool _isFlashOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(244, 244, 244, 1),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            color: Color.fromRGBO(244, 244, 244, 1),
            onPressed: () async {
              scanController.pause();
              List<Media>? res = await Utils.imagePicker();
              if (res != null) {
                String code = await Scan.parse(res[0].path!);
                MyDialog(
                  context: context,
                  title: '扫码结果',
                  content: code,
                );
              } else {
                scanController.resume();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: vh,
                child: ScanView(
                  // scanAreaScale: 1,
                  controller: scanController,
                  onCapture: (data) {
                    MyDialog(
                      context: context,
                      title: '扫码结果',
                      content: data,
                    );
                  },
                ),
              ),
              Positioned(
                bottom: bottomAreaHeight,
                left: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(_isFlashOn ? Icons.flash_off : Icons.flash_on),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      scanController.toggleTorchMode();
                      _isFlashOn = !_isFlashOn;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scanController.pause();
  }
}

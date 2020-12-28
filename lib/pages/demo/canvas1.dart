import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_play/variable.dart';

class CanvasPage extends StatefulWidget {
  static const String name = '/canvas';

  @override
  State<StatefulWidget> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  ui.Image image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text('Canvas'),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(bottomAreaHeight),
          child: CustomPaint(
            painter: _Paint(image),
          ),
        ),
      ),
    );
  }

  Future<ui.Image> loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return decodeImageFromList(bytes);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImageFromAssets('assets/images/avatar.png').then((value) {
      setState(() {
        image = value;
      });
    });
  }
}

class _Paint extends CustomPainter {
  double canvasW = 0;
  double canvasH = 0;
  final ui.Image image;

  _Paint(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvasW = size.width;
    canvasH = size.height;

    // 网格
    final gridPaint = Paint();
    gridPaint
      ..strokeWidth = 1
      ..color = Colors.grey;

    canvas.save();
    for (int i = 0;i <= (canvasW / 20);i++) {
      canvas.drawLine(Offset.zero, Offset(0, canvasH), gridPaint);
      canvas.translate(20, 0);
    }
    canvas.restore();

    canvas.save();
    for (int i = 0;i <= (canvasH / 20);i++) {
      canvas.drawLine(Offset.zero, Offset(canvasW, 0), gridPaint);
      canvas.translate(0, 20);
    }
    canvas.restore();

    // 坐标轴
    final xyPaint = Paint();
    xyPaint
      ..strokeWidth = 4
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(40, 200), Offset(40,0), xyPaint);
    canvas.drawLine(Offset(40, 0), Offset(30,10), xyPaint);
    canvas.drawLine(Offset(40, 0), Offset(50,10), xyPaint);
    canvas.drawLine(Offset(40, 200), Offset(240, 200), xyPaint);
    canvas.drawLine(Offset(240, 200), Offset(230, 190), xyPaint);
    canvas.drawLine(Offset(240, 200), Offset(230, 210), xyPaint);
    final List<Offset> points = [Offset(60, 160), Offset(80, 160), Offset(100, 120), Offset(120, 60), Offset(140, 80), Offset(160, 100), Offset(180, 20),Offset(200, 40)];
    canvas.drawPoints(
      ui.PointMode.polygon,
      points,
      xyPaint..color = Colors.red,
    );
    canvas.drawPoints(
      ui.PointMode.points,
      points,
      xyPaint..color = Colors.black..strokeWidth = 8,
    );

    // 圆
    canvas.drawCircle(Offset(canvasW/2, canvasH/2), 60, Paint()..color = Colors.blue);
    // 旋转
    canvas.save();
    canvas.translate(canvasW/2, canvasH/2);
    for (int i = 0;i < 12;i++) {
      canvas.drawLine(
        Offset(0, -80),
        Offset(0, -100),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 4
      );
      canvas.rotate(2 * pi / 12);
    }
    canvas.restore();
    // 圆弧
    canvas.drawArc(
      Rect.fromLTWH(0, 500, 80, 80),
      pi / 8,
      pi * (2 - 2/8),
      true,
      Paint()..color = Colors.yellow
    );
    // 图片
    if (image!=null) {
      canvas.drawImage(image, Offset(100, 500), Paint());
    }
    // 文字
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'Flutter Play',
        style: TextStyle(
          color: Colors.deepOrange,
          backgroundColor: Colors.blueGrey,
          fontSize: 36,
          // foreground: Paint()..style = PaintingStyle.stroke..color = Colors.deepOrange,
        ),
      ),
      textDirection: TextDirection.ltr,
      // maxLines: 2,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(100, 450));
  }

  @override
  bool shouldRepaint(_Paint oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.image != image;
  }
}
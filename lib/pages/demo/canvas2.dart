import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_play/variable.dart';

class CanvasPage2 extends StatefulWidget {
  static const String name = '/canvas2';

  @override
  State<StatefulWidget> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text('Canvas2'),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(bottomAreaHeight),
          child: CustomPaint(
            painter: _Paint(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}

class _Paint extends CustomPainter {
  double canvasW = 0;
  double canvasH = 0;

  @override
  void paint(Canvas canvas, Size size) {
    canvasW = size.width;
    canvasH = size.height;

    // 网格
    final gridPaint = Paint();
    gridPaint
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..color = Colors.grey;
    double gridStep = 20;

    Path gridPath = Path();
    for (int i = 0;i < canvasW / gridStep;i++) {
      gridPath.moveTo(i * gridStep, 0);
      gridPath.relativeLineTo(0, canvasH);
    }
    for (int i = 0;i < canvasH / gridStep;i++) {
      gridPath.moveTo(0, i * gridStep);
      gridPath.relativeLineTo(canvasW, 0);
    }
    canvas.drawPath(gridPath, gridPaint);

    Path path1 = Path();
    path1
      ..moveTo(0, 0)
      ..lineTo(100, 0)
      ..lineTo(40, 40)
      ..close();
    canvas.drawPath(path1, Paint()..color = Colors.red);

    path1.reset();
    path1
      ..moveTo(0, 100)
      ..relativeLineTo(100, 0)
      ..relativeLineTo(-60, 40)
      ..close();
    canvas.drawPath(path1, Paint()..color = Colors.green);

    path1.reset();
    path1
      ..moveTo(0, 200)
      ..lineTo(100, 200)
      ..arcTo(
          Rect.fromCenter(center: Offset(100, 200), width: 80, height: 80),
          0,
          pi * 3 / 2,
          true)
      ..addRect(Rect.fromLTWH(100, 160, 20, 20));

    canvas.drawPath(
        path1,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
  }

  @override
  bool shouldRepaint(_Paint oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

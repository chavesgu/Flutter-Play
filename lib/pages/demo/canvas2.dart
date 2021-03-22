import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CanvasPage2 extends StatefulWidget {
  static const String name = '/canvas2';

  @override
  State<StatefulWidget> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage2>
    with SingleTickerProviderStateMixin {
  AnimationController? scanController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text('Canvas2'),
        ),
      ),
      body: ClipRect(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: _Paint(context, scanController!),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    scanController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    scanController!.repeat();
    super.initState();
  }

  @override
  void dispose() {
    scanController?.stop();
    scanController?.dispose();
    super.dispose();
  }
}

class _Paint extends CustomPainter {
  _Paint(
    this.context,
    this.scanController, {
    this.scanScale = 0.7,
  }) : super(repaint: scanController);

  final AnimationController scanController;
  final BuildContext context;
  final double scanScale;

  double canvasW = 0;
  double canvasH = 0;
  Tween scanLinePositionTween = Tween(begin: 0, end: 1);
  Animation<double>? scanLinePosition;

  @override
  void paint(Canvas canvas, Size size) {
    canvasW = size.width;
    canvasH = size.height;
    // double dpr = MediaQuery.of(context).devicePixelRatio;

    double areaWidth = min(canvasW, canvasH) * scanScale;
    double scanLineWidth = areaWidth * 0.8;
    double scanLineX = (canvasW - scanLineWidth) / 2;
    double scanLineY = (canvasH - scanLineWidth) / 2 +
        scanLinePositionTween.evaluate(scanController) * scanLineWidth;
    if (scanScale < 1) {
      // 绘制scan区域透明
      canvas.drawRect(
          Rect.fromCenter(
            center: Offset(canvasW / 2, canvasH / 2),
            width: areaWidth,
            height: areaWidth,
          ),
          Paint()..color = Colors.transparent);
      // 裁剪出二维码识别区域
      canvas.save();
      canvas.clipRect(
          Rect.fromCenter(
            center: Offset(canvasW / 2, canvasH / 2),
            width: areaWidth,
            height: areaWidth,
          ),
          clipOp: ui.ClipOp.difference);
      // 绘制mask
      Paint maskPaint = Paint();
      maskPaint.color = Colors.black.withOpacity(0.5);
      maskPaint.style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(0, 0, canvasW, canvasH), maskPaint);
      canvas.restore();
    }
    // 绘制angle line
    double angleLineWidth = areaWidth * 0.1;
    Paint linePaint = Paint();
    linePaint
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3;
    Path angleLinePath = Path();
    angleLinePath.moveTo((canvasW - areaWidth) / 2, (canvasH - areaWidth) / 2);
    angleLinePath.relativeLineTo(angleLineWidth, 0);
    angleLinePath.moveTo((canvasW - areaWidth) / 2, (canvasH - areaWidth) / 2);
    angleLinePath.relativeLineTo(0, angleLineWidth);

    angleLinePath.moveTo(
        canvasW - (canvasW - areaWidth) / 2, (canvasH - areaWidth) / 2);
    angleLinePath.relativeLineTo(-angleLineWidth, 0);
    angleLinePath.moveTo(
        canvasW - (canvasW - areaWidth) / 2, (canvasH - areaWidth) / 2);
    angleLinePath.relativeLineTo(0, angleLineWidth);

    angleLinePath.moveTo(canvasW - (canvasW - areaWidth) / 2,
        canvasH - (canvasH - areaWidth) / 2);
    angleLinePath.relativeLineTo(-angleLineWidth, 0);
    angleLinePath.moveTo(canvasW - (canvasW - areaWidth) / 2,
        canvasH - (canvasH - areaWidth) / 2);
    angleLinePath.relativeLineTo(0, -angleLineWidth);

    angleLinePath.moveTo(
        (canvasW - areaWidth) / 2, canvasH - (canvasH - areaWidth) / 2);
    angleLinePath.relativeLineTo(angleLineWidth, 0);
    angleLinePath.moveTo(
        (canvasW - areaWidth) / 2, canvasH - (canvasH - areaWidth) / 2);
    angleLinePath.relativeLineTo(0, -angleLineWidth);
    angleLinePath.close();
    canvas.drawPath(angleLinePath, linePaint);
    // scan动画线
    canvas.drawLine(
      Offset(scanLineX, scanLineY),
      Offset(scanLineX + scanLineWidth, scanLineY),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(_Paint oldDelegate) {
    return oldDelegate.scanController != scanController;
  }
}

import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_play/service/service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_play/utils/utils.dart';
import 'package:flutter_play/variable.dart';
import 'package:images_picker/images_picker.dart';
import 'package:flutter_play/store/model.dart';

class ChartDemo extends StatefulWidget {
  static const name = '/chart';

  @override
  State<StatefulWidget> createState() => ChartDemoState();
}

class ChartDemoState extends State<ChartDemo> {
  GlobalKey chartKey = GlobalKey();
  GlobalModel get globalModel => Get.find<GlobalModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text('chart demo'),
      ),
      body: ListView(
        children: [
          Obx(() {
            RxList data = globalModel.data73;
            if (data.isNotEmpty) {
              List calcData = getCalcData(data);
              double minY = calcData
                  .map((e) => e['b'].toDouble() * 100)
                  .toList()
                  .reduce((a, b) {
                return min<double>(a, b);
              });
              double maxY = calcData
                  .map((e) => e['b'].toDouble() * 100)
                  .toList()
                  .reduce((a, b) {
                return max<double>(a, b);
              });
              return RepaintBoundary(
                key: chartKey,
                child: Container(
                  color: Colors.white,
                  height: 300,
                  padding: EdgeInsets.all(30),
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          tooltipBgColor: Colors.red.withOpacity(0.8),
                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                              final TextStyle textStyle = TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              );
                              return LineTooltipItem(
                                  '${touchedSpot.y.toStringAsFixed(2)}%',
                                  textStyle);
                            }).toList();
                          },
                        ),
                        handleBuiltInTouches: true,
                        getTouchedSpotIndicator: (barData, indicators) {
                          return indicators.map((int index) {
                            /// Indicator Line
                            Color lineColor = Colors.red;
                            const double lineStrokeWidth = 2;
                            final FlLine flLine = FlLine(
                                color: lineColor, strokeWidth: lineStrokeWidth);
                            // double dotSize = 4;
                            final dotData = FlDotData(
                              show: false,
                            );
                            return TouchedSpotIndicatorData(flLine, dotData);
                          }).toList();
                        },
                      ),
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 15,
                      ),
                      borderData: FlBorderData(
                        border: const Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          left: BorderSide.none,
                          right: BorderSide.none,
                          top: BorderSide.none,
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: () {
                            List<FlSpot> res = [];
                            calcData.asMap().forEach((index, item) {
                              res.add(FlSpot(index.toDouble(),
                                  item['b'].toDouble() * 100));
                            });
                            return res;
                          }(),
                          isCurved: true,
                          barWidth: 1,
                          colors: [
                            Colors.blue,
                          ],
                          belowBarData: BarAreaData(
                            show: true,
                            gradientFrom: Offset(0, 1),
                            gradientTo: Offset(0, 0),
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.blue.withOpacity(0.3),
                            ],
                          ),
                          dotData: FlDotData(
                            show: false,
                          ),
                        )
                      ],
                      maxY: maxY * 1.8,
                      minY: minY * 1.8,
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(
                            showTitles: true,
                            margin: 20,
                            getTitles: (val) {
                              return calcData[val.toInt()]['date'];
                            },
                            checkToShowTitle: (double minValue,
                                double maxValue,
                                SideTitles sideTitles,
                                double appliedInterval,
                                double value) {
                              return value.toInt() == minValue ||
                                  value.toInt() == maxValue;
                            }),
                        leftTitles: SideTitles(
                          showTitles: true,
                          interval: 10,
                          margin: 10,
                          reservedSize: 50,
                          getTitles: (value) {
                            return '${value.toStringAsFixed(2)}%';
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
          ElevatedButton(
            child: Text('saveImage'),
            onPressed: () {
              saveImage();
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Service.getHuoLi73Data().then((value) {
      globalModel.data73.clear();
      globalModel.data73.addAll(value);
    });
  }

  List getCalcData(RxList data) {
    String date = data.first['date'];
    DateTime firstDate = DateTime(int.parse(date.split('-').first) - 3,
        int.parse(date.split('-')[1]), int.parse(date.split('-')[2]));
    int startIndex = data.indexOf(data.firstWhere((obj) {
      return DateTime.parse(obj['date']).millisecondsSinceEpoch <=
          firstDate.millisecondsSinceEpoch;
    }));
    List sortData = data.getRange(0, startIndex).toList().reversed.toList();
    for (int i = 0; i < sortData.length; i++) {
      if (i > 0) {
        final prev = sortData[i - 1];
        sortData[i]['a'] =
            (1 + prev['a']) * (1 + double.parse(prev['base']) / 10000) - 1;
        sortData[i]['b'] = (double.parse(sortData[i]['index']) -
                double.parse(sortData[0]['index'])) /
            double.parse(sortData[0]['index']);
      } else {
        sortData[i]['a'] = 0;
        sortData[i]['b'] = 0;
      }
    }
    List calcData = sortData
        .map((item) => {
              'date': item['date'],
              'a': item['a'],
              'b': item['b'],
            })
        .toList();
    return calcData;
  }

  saveImage() async {
    Loading.show();
    RenderRepaintBoundary boundary =
        chartKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: dpr);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    File file = await Utils.bytesToFile(byteData!);
    bool res = await ImagesPicker.saveImageToAlbum(file);
    await Loading.hide();
    Toast.show(res ? '保存成功' : '保存失败');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:extended_image/extended_image.dart';

import 'package:flutter_play/variable.dart';
import 'package:flutter_play/components/GlobalComponents.dart';

class ImagePreview extends StatefulWidget {
  ImagePreview({
    this.current = 0,
    required this.imageList,
  });

  final List<String> imageList;
  final int current;

  @override
  State<StatefulWidget> createState() {
    return _ImagePreviewState(current);
  }
}

class _ImagePreviewState extends State<ImagePreview> {
  _ImagePreviewState(int current) {
    _current = current;
  }
  int? _current;

  @override
  Widget build(BuildContext context) {
    // 指定状态栏白色文字
    return MyBrightness(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            ExtendedImageGesturePageView(
              physics: ClampingScrollPhysics(),
              controller: PageController(initialPage: _current!),
              onPageChanged: _pageChange,
              children: _renderImage(widget.imageList, context),
            ),
            Positioned(
              top: 20 + statusBarHeight,
              width: vw,
              child: Center(
                child: Text(
                  '${_current! + 1}/${widget.imageList.length}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _renderImage(List<String> list, context) {
    final List<Widget> res = [];
    for (var i = 0; i < list.length; i++) {
      res.add(GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: vw,
          height: vh,
          color: Colors.black,
          child: MyImage(
            list[i],
            mode: ExtendedImageMode.gesture,
            preview: false,
          ),
        ),
      ));
    }
    return res;
  }

  _pageChange(int index) {
    setState(() {
      _current = index;
    });
  }
}

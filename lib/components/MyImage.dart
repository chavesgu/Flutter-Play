import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';

import 'MyBrightness.dart';
import '../variable.dart';
import './Blur.dart';

class MyImage extends StatelessWidget {
  MyImage(
    this.image, {
    this.loadingWidget,
    this.failedWidget,
    this.fit = BoxFit.fitWidth,
    this.width,
    this.height,
    this.mode = ExtendedImageMode.none,
    this.border,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.loadingSize = 50,
    this.color,
    this.colorBlendMode,
    this.scale = 1.0,
    this.preview = false,
    this.gestureConfig,
    this.cacheName = CACHE_NAME,
    this.cacheLocal = false,
  }) : assert(image is String || image is File || image is Uint8List,
            'param image must be String or File or Uint8List');

  static const CACHE_NAME = 'image_cache';

  final dynamic image;
  final Widget? loadingWidget;
  final double loadingSize;
  final Widget? failedWidget;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final ExtendedImageMode mode;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final Color? color;
  final BlendMode? colorBlendMode;
  final double scale;
  final BoxShape shape;
  final InitGestureConfigHandler? gestureConfig;
  final bool preview;
  final String cacheName;
  final bool cacheLocal;

  @override
  Widget build(BuildContext context) {
    ExtendedImage? _imageWidget;
    if (image is Uint8List) {
      _imageWidget = ExtendedImage.memory(
        image,
        width: width,
        height: height,
        color: color,
        scale: scale,
        shape: shape,
        border: border,
        borderRadius: borderRadius,
        colorBlendMode: colorBlendMode,
        loadStateChanged: _loadStateChanged,
        fit: fit,
        mode: mode,
        initGestureConfigHandler: gestureConfig ?? _gestureConfig,
        imageCacheName: cacheName,
      );
    } else if (image is File) {
      _imageWidget = ExtendedImage.file(
        image,
        width: width,
        height: height,
        color: color,
        scale: scale,
        shape: shape,
        border: border,
        borderRadius: borderRadius,
        colorBlendMode: colorBlendMode,
        loadStateChanged: _loadStateChanged,
        fit: fit,
        mode: mode,
        initGestureConfigHandler: gestureConfig ?? _gestureConfig,
        imageCacheName: cacheName,
      );
    } else if (image is String) {
      if (RegExp(r"^https?:\/\/\S+").hasMatch(image)) {
        _imageWidget = ExtendedImage.network(
          image,
          width: width,
          height: height,
          color: color,
          scale: scale,
          shape: shape,
          border: border,
          borderRadius: borderRadius,
          colorBlendMode: colorBlendMode,
          loadStateChanged: _loadStateChanged,
          fit: fit,
          mode: mode,
          initGestureConfigHandler: gestureConfig ?? _gestureConfig,
          cache: cacheLocal,
          imageCacheName: cacheName,
        );
      } else if (RegExp(r"^assets\/\S+").hasMatch(image)) {
        _imageWidget = ExtendedImage.asset(
          image,
          width: width,
          height: height,
          color: color,
          scale: scale,
          shape: shape,
          border: border,
          borderRadius: borderRadius,
          colorBlendMode: colorBlendMode,
          loadStateChanged: _loadStateChanged,
          fit: fit,
          mode: mode,
          initGestureConfigHandler: gestureConfig ?? _gestureConfig,
          imageCacheName: cacheName,
        );
      } else {
        _imageWidget = ExtendedImage.file(
          File(image),
          width: width,
          height: height,
          color: color,
          scale: scale,
          shape: shape,
          border: border,
          borderRadius: borderRadius,
          colorBlendMode: colorBlendMode,
          loadStateChanged: _loadStateChanged,
          fit: fit,
          mode: mode,
          initGestureConfigHandler: gestureConfig ?? _gestureConfig,
          imageCacheName: cacheName,
        );
      }
    }
    if (preview) {
      return OpenContainer(
        clipBehavior: Clip.hardEdge,
        transitionDuration: Duration(milliseconds: 400),
        closedElevation: 0,
        openElevation: 0,
        closedColor: Colors.transparent,
        openColor: Colors.transparent,
        closedBuilder: (_, action) => _imageWidget!,
        openBuilder: (_, action) => ImagePreview(
          imageList: [image, image],
        ),
      );
    }
    return _imageWidget!;
  }

  Widget? _loadStateChanged(ExtendedImageState state) {
    if (state.extendedImageLoadState == LoadState.loading) {
      return loadingWidget ??
          Center(
            child: SizedBox(
              width: loadingSize,
              height: loadingSize,
              child: CircularProgressIndicator(),
            ),
          );
    }
    if (state.extendedImageLoadState == LoadState.failed) {
      return failedWidget ??
          GestureDetector(
            child: Icon(Icons.error),
            onTap: () {
              state.reLoadImage();
            },
          );
    }
  }

  GestureConfig _gestureConfig(ExtendedImageState state) {
    return GestureConfig(
      inPageView: false,
      initialScale: 1.0,
      cacheGesture: false,
    );
  }

  static void clear([String cacheName = CACHE_NAME]) {
    clearMemoryImageCache(cacheName);
  }
}

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
          Get.back();
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

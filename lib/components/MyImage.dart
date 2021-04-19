import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_play/pages/global/imagePreview.dart';
import 'package:get/get.dart';

import '../variable.dart';

class MyImage extends StatelessWidget {
  MyImage(
    this.image, {
    this.loadingWiget,
    this.failWidget,
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
  }) : assert(image is String || image is File || image is Uint8List,
            'param image must be String or File or Uint8List');

  final dynamic image;
  final Widget? loadingWiget;
  final Widget? failWidget;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final ExtendedImageMode mode;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final double loadingSize;
  final Color? color;
  final BlendMode? colorBlendMode;
  final double scale;
  final BoxShape shape;
  final InitGestureConfigHandler? gestureConfig;
  final bool preview;

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
      );
    } else if (image is String) {
      if (RegExp(r"^https?:\/\/\S+").hasMatch(image)) {
        // network
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
        );
      }
    }
    if (preview) {
      TapDownDetails? _details;
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          _details = details;
        },
        onTap: () {
          _previewImage(context, image, _details!);
        },
        child: _imageWidget,
      );
    }
    return _imageWidget!;
  }

  void _previewImage(
      BuildContext context, dynamic content, TapDownDetails details) {
    double _x = (vw / 2 - details.globalPosition.dx) / (vw / 2);
    double _y = (vh / 2 - details.globalPosition.dy) / (vh / 2);
    navigator?.push(PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation secondaryAnimation) {
        return ScaleTransition(
          scale: animation,
          alignment: Alignment(-_x, -_y),
          child: ImagePreview(
            imageList: [content, content],
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 150),
    ));
  }

  Widget? _loadStateChanged(ExtendedImageState state) {
    if (state.extendedImageLoadState == LoadState.loading) {
      return loadingWiget ??
          Center(
            child: SizedBox(
              width: loadingSize,
              height: loadingSize,
              child: CircularProgressIndicator(),
            ),
          );
    }
    if (state.extendedImageLoadState == LoadState.failed) {
      return failWidget ??
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
        inPageView: false, initialScale: 1.0, cacheGesture: false);
  }
}

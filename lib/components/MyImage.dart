import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_play/pages/global/imagePreview.dart';

import '../variable.dart';

class MyImage extends StatelessWidget{
  MyImage(dynamic image, {
    this.loadingWiget,
    this.failWidget,
    this.fit = BoxFit.fitWidth,
    this.width,
    this.height,
    this.mode = ExtendedImageMode.none,
    this.border,
    this.borderRadius,
    this.shape,
    this.loadingSize = 50,
    this.color,
    this.colorBlendMode,
    this.scale = 1.0,
    this.preview = false,
    this.gestureConfig,
  })
    :
      assert(
      image is String || image is File || image is Uint8List,
      'param image must be String or File or Uint8List'
      ),
      _content = image;

  dynamic _content;
  final Widget loadingWiget;
  final Widget failWidget;
  final BoxFit fit;
  final double width;
  final double height;
  final ExtendedImageMode mode;
  final BoxBorder border;
  final BorderRadiusGeometry borderRadius;
  final double loadingSize;
  final Color color;
  final BlendMode colorBlendMode;
  final double scale;
  final BoxShape shape;
  final InitGestureConfigHandler gestureConfig;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    ExtendedImage _imageWidget;
    if (_content is Uint8List) {
      _imageWidget = ExtendedImage.memory(
        _content,
        width: width,
        height: height,
        color: color,
        scale: scale,
        shape: shape,
        colorBlendMode: colorBlendMode,
        loadStateChanged: _loadStateChanged,
        fit: fit,
        mode: mode,
        initGestureConfigHandler: gestureConfig ?? _gestureConfig,
      );
    } else if (_content is File) {
      _imageWidget = ExtendedImage.file(
        _content,
        width: width,
        height: height,
        color: color,
        scale: scale,
        shape: shape,
        colorBlendMode: colorBlendMode,
        loadStateChanged: _loadStateChanged,
        fit: fit,
        mode: mode,
        initGestureConfigHandler: gestureConfig ?? _gestureConfig,
      );
    } else if (_content is String) {
      if (RegExp(r"^https?:\/\/\S+").hasMatch(_content)) { // network
        _imageWidget = ExtendedImage.network(
          _content,
          width: width,
          height: height,
          color: color,
          scale: scale,
          shape: shape,
          colorBlendMode: colorBlendMode,
          loadStateChanged: _loadStateChanged,
          fit: fit,
          mode: mode,
          initGestureConfigHandler: gestureConfig ?? _gestureConfig,
        );
      } else if (RegExp(r"^assets\/\S+").hasMatch(_content)) {
        _imageWidget = ExtendedImage.asset(
          _content,
          width: width,
          height: height,
          color: color,
          scale: scale,
          shape: shape,
          colorBlendMode: colorBlendMode,
          loadStateChanged: _loadStateChanged,
          fit: fit,
          mode: mode,
          initGestureConfigHandler: gestureConfig ?? _gestureConfig,
        );
      } else {
        _imageWidget = ExtendedImage.file(
          File(_content),
          width: width,
          height: height,
          color: color,
          scale: scale,
          shape: shape,
          colorBlendMode: colorBlendMode,
          loadStateChanged: _loadStateChanged,
          fit: fit,
          mode: mode,
          initGestureConfigHandler: gestureConfig ?? _gestureConfig,
        );
      }
    }
    if (preview) {
      return GestureDetector(
        onTapUp: (TapUpDetails details) {
          _previewImage(context, _content, details);
        },
        child: _imageWidget,
      );
    }
    return _imageWidget;
  }

  void _previewImage(BuildContext context, dynamic content, TapUpDetails details) {
    double _x = (vw/2 - details.globalPosition.dx)/(vw/2);
    double _y = (vh/2 - details.globalPosition.dy)/(vh/2);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
          return ScaleTransition(
            scale: animation,
            alignment: Alignment(
              -_x,
              -_y
            ),
            child: ImagePreview(
              imageList: [content, content],
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 150),
      )
    );
  }

  Widget _loadStateChanged(ExtendedImageState state){
    if (state.extendedImageLoadState==LoadState.loading) {
      return loadingWiget ?? Center(
        child: SizedBox(
          width: loadingSize,
          height: loadingSize,
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (state.extendedImageLoadState==LoadState.failed) {
      return failWidget ?? GestureDetector(
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
      cacheGesture: false
    );
  }
}
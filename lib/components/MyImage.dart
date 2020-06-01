import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

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
  })
    :
      assert(image is String || image is File),
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

  @override
  Widget build(BuildContext context) {
    if (_content is File) {
      return ExtendedImage.file(
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
        initGestureConfigHandler: _gestureConfig,
      );
    } else if (_content is String) {
      if (RegExp(r"^https?:\/\/\S+").hasMatch(_content)) { // network
        return ExtendedImage.network(
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
          initGestureConfigHandler: _gestureConfig,
        );
      } else {
        return ExtendedImage.asset(
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
          initGestureConfigHandler: _gestureConfig,
        );
      }
    }
    return Container();
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
      inPageView: true,
      initialScale: 1.0,
      cacheGesture: false
    );
  }
}
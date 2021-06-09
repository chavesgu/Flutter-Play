import 'package:flutter/material.dart';

class CssBox extends StatelessWidget {
  CssBox({
    this.child,
    this.width,
    this.height,
    this.widthFactor,
    this.heightFactor,
    this.alignment = Alignment.topLeft,
    this.backgroundColor,
    this.gradient,
    this.foregroundColor,
    this.shadow,
    this.clip = false,
    this.shape = BoxShape.rectangle,
    this.borderRadius = const [0],
    this.border,
    this.padding,
    this.margin,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.marginTop = 0,
    this.marginBottom = 0,
    this.marginLeft = 0,
    this.marginRight = 0,
  })  : assert(width == null || widthFactor == null),
        assert(height == null || heightFactor == null),
        assert(backgroundColor == null || gradient == null),
        assert(borderRadius.length <= 4),
        assert(padding == null || padding.length <= 4),
        assert(margin == null || margin.length <= 4);

  final Widget? child;
  final double? width;
  final double? height;
  final double? widthFactor;
  final double? heightFactor;
  final Alignment alignment;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool clip;
  final BoxShape shape;
  final List<double> borderRadius;
  final BoxBorder? border;
  final Gradient? gradient;
  final BoxShadow? shadow;
  final List<double>? padding;
  final List<double>? margin;
  final double paddingTop;
  final double paddingRight;
  final double paddingBottom;
  final double paddingLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final double marginLeft;

  @override
  Widget build(BuildContext context) {
    Widget res;
    Widget container = Container(
      child: child,
      width: width,
      height: height,
      alignment: alignment,
      margin: _margin,
      padding: _padding,
      decoration: BoxDecoration(
        shape: shape,
        gradient: gradient,
        color: backgroundColor,
        borderRadius: _borderRadius,
        border: border,
        boxShadow: shadow != null ? [shadow!] : null,
      ),
      foregroundDecoration: BoxDecoration(
        color: foregroundColor,
      ),
      clipBehavior: clip ? Clip.hardEdge : Clip.none,
    );
    if (widthFactor != null || heightFactor != null) {
      res = FractionallySizedBox(
        alignment: Alignment.topLeft,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: container,
      );
    } else {
      res = container;
    }
    return res;
  }

  BorderRadius get _borderRadius {
    List<double> list = borderRadius;
    double topLeft = 0;
    double topRight = 0;
    double bottomRight = 0;
    double bottomLeft = 0;
    switch (list.length) {
      case 4:
        topLeft = list[0];
        topRight = list[1];
        bottomRight = list[3];
        bottomLeft = list[4];
        break;
      case 3:
        topLeft = list[0];
        topRight = list[1];
        bottomRight = list[2];
        bottomLeft = list[1];
        break;
      case 2:
        topLeft = list[0];
        topRight = list[1];
        bottomRight = list[0];
        bottomLeft = list[1];
        break;
      case 1:
        topLeft = list[0];
        topRight = list[0];
        bottomRight = list[0];
        bottomLeft = list[0];
        break;
    }
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

  EdgeInsets get _padding {
    if (padding != null) {
      return calcEdgeInsets(padding!);
    }
    return EdgeInsets.only(
      top: paddingTop,
      right: paddingRight,
      bottom: paddingBottom,
      left: paddingLeft,
    );
  }

  EdgeInsets get _margin {
    if (margin != null) {
      return calcEdgeInsets(margin!);
    }
    return EdgeInsets.only(
      top: marginTop,
      right: marginRight,
      bottom: marginBottom,
      left: marginLeft,
    );
  }

  EdgeInsets calcEdgeInsets(List<double> list) {
    double top = 0;
    double bottom = 0;
    double left = 0;
    double right = 0;
    switch (list.length) {
      case 4:
        top = list[0];
        right = list[1];
        bottom = list[3];
        left = list[4];
        break;
      case 3:
        top = list[0];
        left = list[1];
        right = list[1];
        bottom = list[2];
        break;
      case 2:
        top = list[0];
        bottom = list[0];
        left = list[1];
        right = list[1];
        break;
      case 1:
        top = list[0];
        right = list[0];
        bottom = list[0];
        left = list[0];
        break;
    }
    return EdgeInsets.only(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
    );
  }
}

import 'package:flutter/material.dart';

class MyFlowDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    // TODO: implement paintChildren
    // Size parentSize = context.size;

    for (int i = 0; i < context.childCount; i++) {}
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

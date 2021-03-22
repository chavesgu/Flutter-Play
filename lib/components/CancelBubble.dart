import 'package:flutter/material.dart';

class CancelBubble extends StatelessWidget {
  CancelBubble({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return NotificationListener(
      onNotification: (_) => true,
      child: child,
    );
  }
}

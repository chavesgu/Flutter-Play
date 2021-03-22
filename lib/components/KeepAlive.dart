import 'package:flutter/material.dart';

class KeepAliveWidget extends StatefulWidget {
  KeepAliveWidget({
    required this.child,
    this.keepAlive = true,
  });
  final Widget child;
  final bool keepAlive;
  @override
  State<StatefulWidget> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAliveWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void didChangeDependencies() {
    updateKeepAlive();
    super.didChangeDependencies();
  }
}


import 'package:flutter/material.dart';

import '../variable.dart';

class Popup extends StatefulWidget {
  Popup({
    Key key,
    @required this.child,
    this.mask = true,
    this.closeOnClickMask = false,
    this.duration = const Duration(milliseconds: 200),
    this.handleHide,
  }): super(key: key);

  final Widget child;
  final bool mask;
  final Duration duration;
  final bool closeOnClickMask;
  final Function handleHide;

  _PopupState _state = _PopupState();
  @override
  State<StatefulWidget> createState() => _state;

  Future<void> hide() async {
    await _state.hide();
  }
}

class _PopupState extends State<Popup> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    Widget content = AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: widget.duration,
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              if (widget.closeOnClickMask) {
                await hide();
                if (widget.handleHide!=null) widget.handleHide();
              }
            },
            child: Container(
              width: vw,
              height: vh,
              color: widget.mask?Colors.black.withOpacity(0.6):Colors.transparent,
            ),
          ),
          // SizedBox(
          //   width: vw,
          //   height: vh,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Flexible(child: widget.child),
          //     ],
          //   ),
          // ),
          Center(
            child: widget.child,
          )
        ],
      ),
    );
    return content;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance
      .addPostFrameCallback((timestamp) {
      setState(() {
        _visible = true;
      });
    });
  }

  Future<void> hide() async {
    setState(() {
      _visible = false;
    });
    await Future.delayed(widget.duration);
  }
}
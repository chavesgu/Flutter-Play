
import 'package:flutter/material.dart';

import '../variable.dart';

class MyToast extends StatefulWidget {
  MyToast({
    this.msg,
    this.duration,
    this.onComplete,
  });

  final String msg;
  final Duration duration;
  final Function onComplete;

  @override
  State<StatefulWidget> createState() => _MyToastState();
}

class _MyToastState extends State<MyToast> {
  bool _visible = false;
  Duration animateTime = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    Widget content = AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: animateTime,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(width(8))),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: width(500)
          ),
          color: Color.fromRGBO(0, 0, 0, .9),
          padding: EdgeInsets.only(
            left: width(30),
            right: width(30),
            top: width(20),
            bottom: width(20)
          ),
          child: Text(
            widget.msg,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              height: 1.2,
              fontSize: width(30),
              color: Colors.white,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
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
        _wait();
      });
    });
  }

  void _wait() async {
    await Future.delayed(widget.duration);
    setState(() {
      _visible = false;
      Future.delayed(animateTime).whenComplete(() {
        if (widget.onComplete!=null) widget.onComplete();
      });
    });
  }
}
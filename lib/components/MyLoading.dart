
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../variable.dart';
import 'MyCircularProgressIndicator.dart';

class MyLoading extends StatefulWidget {
  MyLoading({
    this.msg,
    this.duration,
    this.onComplete,
  });

  final String msg;
  final Duration duration;
  final Function onComplete;

  @override
  State<StatefulWidget> createState() => _MyLoadingState();
}

class _MyLoadingState extends State<MyLoading> {
  bool _visible = false;
  Duration animateTime = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    Widget content = AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: animateTime,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(width(20))),
        child: Container(
          width: width(320),
          height: width(320),
          padding: EdgeInsets.only(
            left: width(20),
            right: width(20),
          ),
          color: Color.fromRGBO(0, 0, 0, .7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width(100),
                height: width(100),
                child: MyCircularProgressIndicator(),
                // child: CupertinoActivityIndicator(
                //   radius: 50,
                // ),
              ),
              widget.msg==null?SizedBox.shrink():Container(
                margin: EdgeInsets.only(top: width(50)),
                child: Text(
                  widget.msg,
                  maxLines: 1,
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
            ],
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
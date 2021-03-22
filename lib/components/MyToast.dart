import 'package:flutter/material.dart';

import '../variable.dart';

class MyToast extends StatefulWidget {
  MyToast(this.msg);

  final String msg;

  @override
  State<StatefulWidget> createState() => _MyToastState();
}

class _MyToastState extends State<MyToast> {
  @override
  Widget build(BuildContext context) {
    Widget content = ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(width(8))),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: width(500),
        ),
        color: Color.fromRGBO(0, 0, 0, .9),
        padding:
            EdgeInsets.only(left: width(30), right: width(30), top: width(20), bottom: width(20)),
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
    );
    return content;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}

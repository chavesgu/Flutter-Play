
import 'package:flutter/material.dart';

class MyCircularProgressIndicator extends StatefulWidget{
  MyCircularProgressIndicator({
    this.strokeWidth = 4.0,
  });

  final double strokeWidth;

  @override
  State<StatefulWidget> createState() => _MyCircularProgressIndicatorState();
}

class _MyCircularProgressIndicatorState extends State<MyCircularProgressIndicator> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> tween;
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: widget.strokeWidth,
      backgroundColor: Colors.transparent,
      valueColor: tween,
    );
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat();
    _animationController.addListener(() {
      setState(() => {});
    });
    tween = TweenSequence<Color>([
      TweenSequenceItem(
        weight: 0.2,
        tween: ColorTween(
          begin: Colors.purple,
          end: Colors.red,
        ),
      ),
      TweenSequenceItem(
        weight: 0.2,
        tween: ColorTween(
          begin: Colors.red,
          end: Colors.yellow,
        ),
      ),
      TweenSequenceItem(
        weight: 0.2,
        tween: ColorTween(
          begin: Colors.yellow,
          end: Colors.blue,
        ),
      ),
      TweenSequenceItem(
        weight: 0.2,
        tween: ColorTween(
          begin: Colors.blue,
          end: Colors.purple,
        ),
      ),
    ]).animate(_animationController);
    super.initState();
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

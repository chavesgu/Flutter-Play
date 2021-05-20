import 'package:flutter/material.dart';

class MyCircularProgressIndicator extends StatefulWidget {
  MyCircularProgressIndicator({
    this.strokeWidth = 4.0,
  });

  final double strokeWidth;

  @override
  State<StatefulWidget> createState() => _MyCircularProgressIndicatorState();
}

class _MyCircularProgressIndicatorState
    extends State<MyCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<Color>? tween;
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
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController!.repeat();
    _animationController!.addListener(() {
      setState(() => {});
    });
    tween = TweenSequence<Color>([
      TweenSequenceItem(
        weight: 0.2,
        tween: _ColorTween(
          begin: Color(0xff4284F4),
          end: Color(0xffEA4336),
        ),
      ),
      TweenSequenceItem(
        weight: 0.2,
        tween: _ColorTween(
          begin: Color(0xffEA4336),
          end: Color(0xffFABD05),
        ),
      ),
      TweenSequenceItem(
        weight: 0.2,
        tween: _ColorTween(
          begin: Color(0xffFABD05),
          end: Color(0xff33A853),
        ),
      ),
      TweenSequenceItem(
        weight: 0.2,
        tween: _ColorTween(
          begin: Color(0xff33A853),
          end: Color(0xff4284F4),
        ),
      ),
    ]).animate(_animationController!);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}

class _ColorTween extends Tween<Color> {
  /// Creates a [Color] tween.
  ///
  /// The [begin] and [end] properties may be null; the null value
  /// is treated as transparent.
  ///
  /// We recommend that you do not pass [Colors.transparent] as [begin]
  /// or [end] if you want the effect of fading in or out of transparent.
  /// Instead prefer null. [Colors.transparent] refers to black transparent and
  /// thus will fade out of or into black which is likely unwanted.
  _ColorTween({required Color begin, required Color end})
      : super(begin: begin, end: end);

  /// Returns the value this variable has at the given animation clock value.
  @override
  Color lerp(double t) => Color.lerp(begin!, end!, t)!;
}

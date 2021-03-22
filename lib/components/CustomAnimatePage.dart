import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRouteBuilder extends PageRouteBuilder {
  final Widget enterWidget;
  CustomRouteBuilder({required this.enterWidget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return enterWidget;
          },
          transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) {
            if (animation.status != AnimationStatus.reverse) {
              // return SlideTransition(
              //   position: new Tween<Offset>(
              //     begin: Offset(1.0, 0.0),
              //     end: Offset.zero,
              //   ).animate(animation),
              //   child: child
              // );
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            } else {
              return CupertinoPageTransition(
                linearTransition: true,
                primaryRouteAnimation: animation,
                secondaryRouteAnimation: secondaryAnimation,
                child: child,
              );
            }
          },
        );
}

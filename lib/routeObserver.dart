import 'package:flutter/material.dart';

class MyRouteObserve extends NavigatorObserver {

  @override
  void didPop(Route route, Route previousRoute) {
    // TODO: implement didPop
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    // TODO: implement didPush
    print(route.settings);
    super.didPush(route, previousRoute);
  }
}
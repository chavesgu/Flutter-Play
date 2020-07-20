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
    print(route.settings.name);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({ Route<dynamic> newRoute, Route<dynamic> oldRoute }) {
    // TODO: implement didPush
    print(newRoute.settings.name);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
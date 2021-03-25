import 'package:flutter/material.dart';

class RouteObserverUtil {
  RouteObserverUtil._();

  static RouteObserver<PageRoute> _routeObserver;

  static RouteObserver<PageRoute> get routeObserver {
    _routeObserver ??= RouteObserver<PageRoute>();
    return _routeObserver;
  }
}

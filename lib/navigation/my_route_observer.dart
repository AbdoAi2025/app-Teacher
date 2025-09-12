import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 🔹 Custom Route Observer (tracks navigation)
class MyRouteObserver extends GetObserver {
  static final List<Route<dynamic>> history = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    history.add(route);
    print("PUSH: ${route.settings.name}");
    print("STACK: ${history.map((r) => r.settings.name).toList()}");
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    history.remove(route);
    print("POP: ${route.settings.name}");
    print("STACK: ${history.map((r) => r.settings.name).toList()}");
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    history.remove(route);
    print("REMOVE: ${route.settings.name}");
    print("STACK: ${history.map((r) => r.settings.name).toList()}");
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute != null) history.remove(oldRoute);
    if (newRoute != null) history.add(newRoute);
    print("REPLACE: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}");
    print("STACK: ${history.map((r) => r.settings.name).toList()}");
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

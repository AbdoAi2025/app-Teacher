
import 'package:flutter/material.dart';
import '../main.dart';


abstract class LifecycleWidgetState<T extends StatefulWidget> extends State<T> with RouteAware {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    print("LifecycleWidgetState $this onResume (first time opened)");
  }

  @override
  void didPopNext() {
    print("LifecycleWidgetState️ $this onResume (navigated back to this screen)");
    onResumedNavigatedBack();
  }

  @override
  void didPushNext() {
    print("LifecycleWidgetState $this onPause (navigated away from this screen)");
    onPausedNavigatedAway();
  }

  @override
  void didPop() {
    print("LifecycleWidgetState $this onPause (screen closed)");
  }

  void onResumedNavigatedBack() {}

  void onPausedNavigatedAway() {}

}

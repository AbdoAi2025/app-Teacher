
import 'package:flutter/material.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import '../main.dart';


abstract class LifecycleWidgetState<T extends StatefulWidget> extends State<T> with RouteAware, WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

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
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _print("didChangeAppLifecycleState $this state : $state");
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _print("didChangeAppLifecycleState $this onAppResumed (app came to foreground)");
        onAppResumed();
        break;
      case AppLifecycleState.paused:
        _print(" $this onAppPaused (app went to background)");
        onAppPaused();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:{}
    }
  }

  @override
  void didPush() {
    _print(" $this onResume (first time opened)");
    onFirstTimeOpened();
  }

  @override
  void didPopNext() {
    _print(" $this onResume (navigated back to this screen)");
    onResumedNavigatedBack();
  }

  @override
  void didPushNext() {
    _print(" $this onPause (navigated away from this screen)");
    onPausedNavigatedAway();
  }

  @override
  void didPop() {
    _print(" $this onPause (screen closed)");
  }

  void onResumedNavigatedBack() {}

  void onPausedNavigatedAway() {}

  void onFirstTimeOpened() {}

  void onAppResumed() {}

  void onAppPaused() {}

  void _print(String s) {
    appLog("LifecycleWidgetState $this $s");
  }

}

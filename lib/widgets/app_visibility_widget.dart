import 'package:flutter/cupertino.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../utils/LogUtils.dart';

class AppVisibilityWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onVisible;
  final VoidCallback? onHidden;

  const AppVisibilityWidget(
      {required super.key,
      required this.child,
       this.onVisible,
       this.onHidden});

  @override
  Widget build(BuildContext context) {

   // return FocusableActionDetector(
   //     child: child,
   //   onFocusChange: (value){
   //       appLog("onFocusChange value : $value");
   //   },
   // );


    return VisibilityDetector(
      key: key!,
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        appLog("onVisibilityChanged context.mounted: ${context.mounted}");
        appLog("onVisibilityChanged visiblePercentage: $visiblePercentage");
        appLog("onVisibilityChanged visibleBounds: ${visibilityInfo.visibleBounds}");
        appLog("onVisibilityChanged runtimeType: ${visibilityInfo.runtimeType}");
        appLog("onVisibilityChanged size: ${visibilityInfo.size}");
        if (visiblePercentage > 0) {
          // 👇 Called when user navigates back and widget is shown again
          onVisible?.call();
        } else {
          // 👇 Called when widget is hidden (navigating away)
          onHidden?.call();
        }
      },
      child: child,
    );
  }
}

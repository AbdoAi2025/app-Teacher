import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/widgets/loading_widget.dart';

var _isShowLoading = false;

showDialogLoading() {
  var context = Get.context;
  if (context == null) return;
  appLog(
      "dialog loading show _context:$context, _isShowLoading:$_isShowLoading");
  if (_isShowLoading) return;
  _isShowLoading = true;

  showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: _loadingWidget(),
        );
      });
}

_loadingWidget() => Center(
      child: SizedBox(width: 40, height: 40, child: LoadingWidget()),
    );

hideDialogLoading() {
  var context = Get.context;
  appLog(
      "dialog loading hide _context:$context, _isShowLoading:$_isShowLoading");
  if (context == null) return;
  if (_isShowLoading) {
    Get.back();
    // Navigator.pop(context);
    _isShowLoading = false;
  }
}

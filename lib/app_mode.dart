


import 'package:flutter/foundation.dart';

class AppMode{
  AppMode._();
  static const int dev = 0;
  static const int prod = 1;
  static const int local = 2;

  // static const int mode = local;
  static const int mode = prod;


  static bool isDev = mode == AppMode.dev;
  static bool isProd = mode == AppMode.prod;
  static bool isLocal = mode == AppMode.local;
  static bool idDebug = kDebugMode;
}
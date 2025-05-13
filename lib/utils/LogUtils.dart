


import 'package:flutter/foundation.dart';

appLog(String message , [String tag = "assistantApp"]){
  if (kDebugMode) {
    print("$tag: $message");
  }
}
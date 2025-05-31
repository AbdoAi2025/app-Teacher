import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/utils/LogUtils.dart';


class AppDateUtils{


  AppDateUtils._();

  static String getDayName(int day) {
    var days = [
      "Sunday".tr,
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];

    if (day < 0) return "";
    return days[day % 7];
  }


 static TimeOfDay? parseTimeOfDay(String timeString) {

    try{
      final parts = timeString.split(":");
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    }catch(ex){
      appLog("AppDateUtils : ${ex.toString()}");
    }

    return null;

  }

}


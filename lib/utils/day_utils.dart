import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  static DateTime? parseStringToDateTime(String dateString) {
    try{
      final dateTime = DateTime.parse(dateString);
      appLog("parseStringToDateTime dateTime:$dateTime"); // Your device's local time
      // Output: 2025-06-01 22:31:07.017Z
      final localTime = dateTime.toLocal();
      appLog("parseStringToDateTime localTime:$localTime"); // Your device's local time
      return localTime;
    }catch(ex){
      appLog("parseStringToDateTime ex:${ex.toString()}");
      return null;
    }
  }


  static String parsDateToString(DateTime? date, [String format = 'yyyy-MM-dd HH:mm']) {
    try{
      String formatted = DateFormat(format).format(date!);
      return formatted;
    }catch(e){
      appLog("parsDateToString e:${e.toString()}");
      return date?.toString() ?? "";
    }
  }

  static String parsStringToString(String? dateString, [String format = 'yyyy-MM-dd HH:mm']) {
    try{
      String formatted = DateFormat(format).format(parseStringToDateTime(dateString!)!);
      return formatted;
    }catch(e){
      appLog("parsDateToString e:${e.toString()}");
      return dateString ?? "";
    }
  }


  static sessionStartDateToString(DateTime? date){
    return parsDateToString(date, "yyy-MM-dd HH:mm");
  }

}


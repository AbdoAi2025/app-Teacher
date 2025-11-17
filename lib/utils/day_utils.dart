import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/utils/LogUtils.dart';


class AppDateUtils{


  AppDateUtils._();

  static String getDayName(int day) {
    var days = [
      "Sunday",
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

  static String getDayNameEn(int day) {
    var days = [
      "Sunday",
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

  static String getDayNameAr(int day) {
    var days = [
      "الأحد",
      "الاثنين",
      "الثلاثاء",
      "الأربعاء",
      "الخميس",
      "الجمعة",
      "السبت"
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


  static String parsDateToString(DateTime? date, {String format = 'yyyy-MM-dd HH:mm' , String? locale}) {
    try{
      String formatted = DateFormat(format , locale).format(date!);
      return formatted;
    }catch(e){
      appLog("parsDateToString e:${e.toString()}");
      return date?.toString() ?? "";
    }
  }

  static String parsStringToString(String? dateString, [String format = 'yyyy-MM-dd HH:mm' , String? locale]) {
    try{
      String formatted = DateFormat(format , locale).format(parseStringToDateTime(dateString!)!);
      return formatted;
    }catch(e){
      appLog("parsDateToString e:${e.toString()}");
      return dateString ?? "";
    }
  }


  static sessionStartDateToString(DateTime? date){
    return parsDateToString(date, format: "yyy-MM-dd HH:mm");
  }

  /// Parse "HH:mm" into total minutes since midnight
  static int parseTime(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

}


import 'package:get/get.dart';

String getDayName(int day) {
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

ValueNotifier<AppSetting> appSettingNotifier = ValueNotifier(AppSetting());


class AppSetting{
  bool rtlLanguages = true;
  static get appLocal => (Get.locale ?? Locale("en" , "US"));
  static get appLanguage => appLocal.languageCode;
  static bool get isArabic => appLanguage == "ar";
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_auth_model.dart';

ValueNotifier<AppSetting> _appSettingNotifier = ValueNotifier(AppSetting());

ValueNotifier<AppSetting> getAppSettingNotifier() => _appSettingNotifier;

AppSetting getAppSetting() => _appSettingNotifier.value;

updateAppSetting(AppSetting setting) {
  _appSettingNotifier.value = setting;
}


setUserAuthModel(UserAuthModel? model) {
  if(model == null) return;
  updateAppSetting(getAppSetting().copyWith(accessToken: model.accessToken));
}


class AppSetting{
  bool rtlLanguages = true;
  String accessToken = "";
  static get appLocal => (Get.locale ?? Locale("en" , "US"));
  static get appLanguage => appLocal.languageCode;
  static bool get isArabic => appLanguage == "ar";

  AppSetting({
     this.rtlLanguages = true,
     this.accessToken = "",
  });


  AppSetting copyWith({
    bool? rtlLanguages,
    String? accessToken,
  }) {
    return AppSetting(
      rtlLanguages: rtlLanguages ?? this.rtlLanguages,
      accessToken: accessToken ?? this.accessToken,
    );
  }


}

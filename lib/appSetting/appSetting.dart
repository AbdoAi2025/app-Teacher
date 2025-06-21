import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/models/app_locale_model.dart';

import '../models/user_auth_model.dart';

ValueNotifier<AppSetting> _appSettingNotifier = ValueNotifier(AppSetting());

ValueNotifier<AppSetting> getAppSettingNotifier() => _appSettingNotifier;



class AppSetting{

  bool rtlLanguages = true;
  String accessToken = "";
  AppLocaleModel? appLocaleModel;

  static get appLocal => (Get.locale ?? Locale("en" , "US"));
  static get appLanguage => appLocal.languageCode;
  static bool get isArabic => appLanguage == "ar";

  AppSetting({
     this.rtlLanguages = true,
     this.accessToken = "",
     this.appLocaleModel,
  });

  AppSetting copyWith({
    bool? rtlLanguages,
    String? accessToken,
    AppLocaleModel? appLocaleModel,
  }) {
    return AppSetting(
      rtlLanguages: rtlLanguages ?? this.rtlLanguages,
      accessToken: accessToken ?? this.accessToken,
      appLocaleModel: appLocaleModel ?? this.appLocaleModel,
    );
  }


  static AppSetting getAppSetting() => _appSettingNotifier.value;

  static updateAppSetting(AppSetting setting) {
    _appSettingNotifier.value = setting;
  }

  static setUserAuthModel(UserAuthModel? model) {
    if(model == null) return;
    updateAppSetting(getAppSetting().copyWith(accessToken: model.accessToken));
  }


  static setAppLocale(AppLocaleModel? model) {
    if(model == null) return;
    updateAppSetting(getAppSetting().copyWith(appLocaleModel: model));
  }

}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:teacher_app/domain/models/app_locale_model.dart';

import '../models/user_auth_model.dart';

ValueNotifier<AppSetting> _appSettingNotifier = ValueNotifier(AppSetting());

ValueNotifier<AppSetting> getAppSettingNotifier() => _appSettingNotifier;



class AppSetting{

  bool rtlLanguages = true;
  String accessToken = "";
  AppLocaleModel? appLocaleModel;
  double? appVersion;

  static get appLocal => (Get.locale ?? Locale("en" , "US"));
  static get appLanguage => appLocal.languageCode;
  static bool get isArabic => appLanguage == "ar";

  AppSetting({
     this.rtlLanguages = true,
     this.accessToken = "",
     this.appLocaleModel,
     this.appVersion,
  });

  AppSetting copyWith({
    bool? rtlLanguages,
    String? accessToken,
    AppLocaleModel? appLocaleModel,
    double? appVersion,
  }) {
    return AppSetting(
      rtlLanguages: rtlLanguages ?? this.rtlLanguages,
      accessToken: accessToken ?? this.accessToken,
      appLocaleModel: appLocaleModel ?? this.appLocaleModel,
      appVersion: appVersion ?? this.appVersion,
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

  static initAppVersion() async{
    var appVersion = await _getAppVersion();
    updateAppSetting(getAppSetting().copyWith(appVersion: appVersion));
  }

  static Future<double?>  _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    String versionName = info.version;      // e.g. "1.2.3"
    String buildNumber = info.buildNumber;  // e.g. "42"
    print("App Version: $versionName ($buildNumber)");

    if(Platform.isIOS){
      String majorMinor = versionName.split(".").take(2).join(".");
      return double.tryParse(majorMinor);
    }
    return double.tryParse(versionName);
  }

}

import 'dart:ui';

import 'package:get/get.dart';

import '../domain/models/app_locale_model.dart';
import '../domain/usecases/get_app_setting_use_case.dart';
import 'LogUtils.dart';

class AppLocalizationUtils {

  static AppLocaleModel _appLocale = AppLocaleModel(language: "en");

  static AppLocaleModel getCurrentLocale() => Get.locale != null
      ? AppLocaleModel(language: Get.locale!.languageCode)
      : _appLocale;

  static void setLocale(AppLocaleModel appLocale) {
    _appLocale = appLocale;
  }
}

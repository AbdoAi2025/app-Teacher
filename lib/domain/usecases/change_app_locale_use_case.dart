
import 'package:get/get.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/data/repositories/appsetting/app_setting_repository.dart';
import 'package:teacher_app/data/repositories/appsetting/app_setting_repository_impl.dart';
import 'package:teacher_app/domain/models/app_locale_model.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../utils/app_localization_utils.dart';

class ChangeAppLocaleUseCase {

  final AppSettingRepository _repository = AppSettingRepositoryImpl();

  Future<AppLocaleModel?> execute(AppLocaleModel model) async {
    try{
      appLog("changeLocale: ${model.language}-${model.country}");
      Get.locale = model.toLocale();
      AppLocalizationUtils.setLocale(model);
      await _repository.setAppLocale(model);
      AppSetting.setAppLocale(model);
      return model;
    }on Exception catch(ex){
      appLog("ex : ${ex.toString()}");
      return  null;
    }
  }
}

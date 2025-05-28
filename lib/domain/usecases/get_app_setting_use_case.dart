import 'package:teacher_app/apimodels/grade_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/appsetting/app_setting_repository.dart';
import 'package:teacher_app/data/repositories/appsetting/app_setting_repository_impl.dart';
import 'package:teacher_app/data/repositories/grades_repository.dart';
import 'package:teacher_app/domain/models/app_locale_model.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class GetAppSettingUseCase {

  AppSettingRepository repository = AppSettingRepositoryImpl();

  Future<AppLocaleModel?> execute() async {
    try{
      return await repository.getAppLocale();
    }on Exception catch(ex){
      appLog("ex : ${ex.toString()}");
      return  null;
    }
  }
}

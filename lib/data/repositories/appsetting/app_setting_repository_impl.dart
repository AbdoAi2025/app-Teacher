
import 'package:teacher_app/data/dataSource/appsetting/app_setting_local_data_source.dart';
import 'package:teacher_app/data/repositories/appsetting/app_setting_repository.dart';

import '../../../domain/models/app_locale_model.dart';

class AppSettingRepositoryImpl extends AppSettingRepository {

  AppSettingLocalDataSource localDataSource = AppSettingLocalDataSource();

  @override
  Future<AppLocaleModel?> getAppLocale() {
    return localDataSource.getAppLocale();
  }

  @override
  Future setAppLocale(AppLocaleModel model) {
    return localDataSource.saveAppLocale(model);
  }


}

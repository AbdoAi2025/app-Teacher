
import '../../../domain/models/app_locale_model.dart';

abstract  class AppSettingRepository {

  Future<AppLocaleModel?> getAppLocale();
  Future<dynamic> setAppLocale(AppLocaleModel model);
}
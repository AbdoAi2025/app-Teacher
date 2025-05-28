import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import '../../../domain/models/app_locale_model.dart';


class AppSettingLocalDataSource {

  static const String _appLocaleKey = "appLocale";

  saveAppLocale(AppLocaleModel model) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var modelToJson = jsonEncode(model.toJson());
    appLog("saveAppLocale modelToJson:$modelToJson");
    await prefs.setString(_appLocaleKey, modelToJson);
  }

  Future<AppLocaleModel?> getAppLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var modelJson = prefs.getString(_appLocaleKey);
    appLog("getUserAuth modelJson:$modelJson");
    if(modelJson == null) return null;
    return AppLocaleModel.fromJson(jsonDecode(modelJson));
  }

}

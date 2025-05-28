import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/models/user_auth_model.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class LocalIdentityDataSource {


  static const _userAuthKey = "userAuth";

  saveUserAuth(UserAuthModel model) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userAuthString = jsonEncode(model.toJson());
    _log("saveUserAuth userAuthString:$userAuthString");
    await prefs.setString(_userAuthKey,userAuthString );
    updateAppSetting(getAppSetting().copyWith(accessToken: model.accessToken));
  }

  Future<UserAuthModel?> getUserAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userAuthString = prefs.getString(_userAuthKey);
    _log("getUserAuth userAuthString:$userAuthString");
    if(userAuthString == null) return null;
    return UserAuthModel.fromJson(jsonDecode(userAuthString));
  }

  void _log(String s) {
    appLog(s , "LocalIdentityDataSource");
  }

}

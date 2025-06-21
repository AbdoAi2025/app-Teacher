import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/models/profile_info_model.dart';
import 'package:teacher_app/models/user_auth_model.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class LocalIdentityDataSource {


  static const _userAuthKey = "userAuth";
  static const _profileInfoKey = "profileInfo";

  saveUserAuth(UserAuthModel? model) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(model == null){
      await prefs.setString(_userAuthKey, "" );
      return;
    }

    var userAuthString = jsonEncode(model.toJson());
    _log("saveUserAuth userAuthString:$userAuthString");
    await prefs.setString(_userAuthKey,userAuthString );
    AppSetting.updateAppSetting(AppSetting.getAppSetting().copyWith(accessToken: model.accessToken));
  }

  Future<UserAuthModel?> getUserAuth() async {

    try{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var userAuthString = prefs.getString(_userAuthKey);
      _log("getUserAuth userAuthString:$userAuthString");
      if(userAuthString == null) return null;
      return UserAuthModel.fromJson(jsonDecode(userAuthString));
    }catch(ex){
      appLog("getUserAuth ex:${ex.toString()}");
    }

    return null;

  }

  void _log(String s) {
    appLog(s , "LocalIdentityDataSource");
  }

  Future<ProfileInfoModel?> getProfileInfo() async {

    try{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var jsonString = prefs.getString(_profileInfoKey);
      _log("getUserAuth jsonString:$jsonString");
      if(jsonString == null) return null;
      return ProfileInfoModel.fromJson(jsonDecode(jsonString));
    }catch(ex){
      appLog("getProfileInfo ex:${ex.toString()}");
    }

    return null;

  }

  Future saveProfileInfo(ProfileInfoModel? model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(model == null){
      await prefs.setString(_profileInfoKey, "" );
      return;
    }

    var jsonString = jsonEncode(model.toJson());
    _log("saveProfileInfo jsonString:$jsonString");
    await prefs.setString(_profileInfoKey,jsonString );
  }

}

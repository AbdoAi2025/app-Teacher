
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/app_config_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/models/check_app_version_model.dart';

import '../../requests/check_app_version_request.dart';

class ChangeAppVersionUseCase extends BaseUseCase<CheckAppVersionModel>{

  final AppConfigRepository _repository = AppConfigRepository();

  Future<AppResult<CheckAppVersionModel>> execute() async {
    return call(() async {

      var appVersion = AppSetting.getAppSetting().appVersion;

      var request = CheckAppVersionRequest(
        version:  appVersion,
        platform: Platform.isAndroid ? 0 : 1 ,
      );

      var model =  await _repository.checkAppVersion(request);
      return AppResult.success(model);
    });
  }



  //
  // Future<double?> _getAndroidVersion() async {
  //   final deviceInfo = DeviceInfoPlugin();
  //   final androidInfo = await deviceInfo.androidInfo;
  //   var versionName = androidInfo.;
  //   var versionCode = androidInfo.version.release;
  //   print("Android OS Version name: $versionName");
  //   print("Android OS versionCode: $versionCode");
  //   print("SDK Int: ${androidInfo.version.sdkInt}");
  //   return double.tryParse(versionName);
  // }
  //
  // Future<double?> _getIOSVersion() async {
  //   final deviceInfo = DeviceInfoPlugin();
  //   final iosInfo = await deviceInfo.iosInfo;
  //   print("iOS Version: ${iosInfo.systemVersion}"); // e.g. 17.5
  //   return double.tryParse(iosInfo.systemVersion);
  // }
}

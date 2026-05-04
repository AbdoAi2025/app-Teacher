import 'package:teacher_app/data/dataSource/identity_remote_data_source.dart';
import 'package:teacher_app/data/dataSource/local_identity_data_source.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/requests/login_request.dart';
import 'package:teacher_app/data/requests/register_request.dart';
import 'package:teacher_app/domain/models/login_model.dart';
import 'package:teacher_app/domain/models/login_result.dart';
import 'package:teacher_app/domain/models/register_model.dart';
import 'package:teacher_app/enums/gender_enum.dart';
import 'package:teacher_app/models/check_user_session_model.dart';
import 'package:teacher_app/models/profile_info_model.dart';
import 'package:teacher_app/models/user_auth_model.dart';
import 'package:teacher_app/services/firebase_service.dart';
import 'package:teacher_app/services/device_info_service.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../../models/subscription_date_model.dart';

class IdentityRepositoryImpl extends IdentityRepository {
  LocalIdentityDataSource localIdentityDataSource = LocalIdentityDataSource();
  IdentityRemoteDataSource remoteIdentityDataSource =
      IdentityRemoteDataSource();

  @override
  Future<UserAuthModel?> getUserAuth() {
    return localIdentityDataSource.getUserAuth();
  }

  @override
  Future<LoginResult> login(LoginModel model) async {
    // Get FCM token before login
    String? fcmToken = await FirebaseService.instance.getFCMToken();
    appLog("Login: FCM Token retrieved - ${fcmToken != null ? '${fcmToken.substring(0, 20)}...' : 'null'}");

    // Get device information
    final deviceInfo = await DeviceInfoService.instance.getDeviceInfo();
    appLog("Login: Device info retrieved - $deviceInfo");

    var response = await remoteIdentityDataSource.login(
        LoginRequest(
          username: model.userName,
          password: model.password,
          fcmToken: fcmToken,
          deviceId: deviceInfo.deviceId,
          deviceName: deviceInfo.deviceName,
          platform: deviceInfo.platform,
        ));

    return LoginResult(
      accessToken: response.accessToken ?? "",
      id: response.id ?? "",
      name: response.name ?? "",
      refreshToken: "",
    );
  }

  @override
  Future<LoginResult> register(RegisterModel model) async {
    // Get FCM token before registration
    String? fcmToken = await FirebaseService.instance.getFCMToken();
    appLog("Register: FCM Token retrieved - ${fcmToken != null ? '${fcmToken.substring(0, 20)}...' : 'null'}");

    // Get device information
    final deviceInfo = await DeviceInfoService.instance.getDeviceInfo();
    appLog("Register: Device info retrieved - $deviceInfo");

    var response = await remoteIdentityDataSource.register(
        RegisterRequest(
            name: model.name,
            username: model.userName,
            password: model.password,
            phoneNumber: model.phone,
            email: model.email,
            gender: model.gender.toJson(),
            subjectId: model.subjectId,
            fcmToken: fcmToken,
            deviceId: deviceInfo.deviceId,
            deviceName: deviceInfo.deviceName,
            platform: deviceInfo.platform,
        ));

    return LoginResult(
      accessToken: response.accessToken ?? "",
      id: response.id ?? "",
      name: response.name ?? "",
      refreshToken: "",
    );
  }

  @override
  Future saveUserAuth(UserAuthModel? userAuthModel) {
    return localIdentityDataSource.saveUserAuth(userAuthModel);
  }

  @override
  Future<ProfileInfoModel?> getProfileInfo() {
    return localIdentityDataSource.getProfileInfo();
  }

  @override
  Future saveProfileInfo(ProfileInfoModel? profileInfoModel) {
    return localIdentityDataSource.saveProfileInfo(profileInfoModel);
  }

  @override
  Future logout() async {
    try {
      // Call remote logout API first
      await remoteIdentityDataSource.logout();
      appLog("Logout: Remote logout successful");

      // Get user info before clearing to unsubscribe from topics
      // final profileInfo = await getProfileInfo();
      // if (profileInfo != null) {
      //   await FirebaseService.instance.clearUser(
      //     userId: profileInfo.id ?? '',
      //     role: 'teacher', // or get from profile if available
      //   );
      // }

      await saveUserAuth(null);
      await saveProfileInfo(null);

      appLog("Logout: User session cleared and FCM topics unsubscribed");
    } catch (e) {
      appLog("Logout: Error during logout process - $e");
      // Still clear local data even if remote logout or Firebase operations fail
      await saveUserAuth(null);
      await saveProfileInfo(null);
    }
  }

  @override
  Future<CheckUserSessionModel> checkUserSession() async {
    var response = await remoteIdentityDataSource.checkUserSession();
    return CheckUserSessionModel(
      isActive: response.data?.active ?? false,
      isSubscribed: response.data?.subscribed ?? false,
      subscriptionExpireDate: SubscriptionDateModel(dateString: response.data?.subscriptionExpireDate ?? ""),
    );
  }
}

import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/fcm_token/fcm_token_repository.dart';
import 'package:teacher_app/data/repositories/fcm_token/fcm_token_repository_impl.dart';
import 'package:teacher_app/data/requests/update_fcm_token_request.dart';
import 'package:teacher_app/data/responses/fcm_token_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/services/device_info_service.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class UpdateFcmTokenUseCase extends BaseUseCase<FcmTokenResponse> {
  final FcmTokenRepository _repository = FcmTokenRepositoryImpl();

  Future<AppResult<FcmTokenResponse>> execute(String fcmToken) async {
    return await call(() async {
      appLog("UpdateFcmTokenUseCase: Starting FCM token update for token: ${fcmToken.substring(0, 20)}...");
      // Get device information
      final deviceInfo = await DeviceInfoService.instance.getDeviceInfo();
      appLog("UpdateFcmTokenUseCase: Device info retrieved - Platform: ${deviceInfo.platform}, DeviceID: ${deviceInfo.deviceId}");
      // Create the request
      final request = UpdateFcmTokenRequest(
        token: fcmToken,
        deviceId: deviceInfo.deviceId,
        deviceName: deviceInfo.deviceName,
        platform: deviceInfo.platform,
      );
      // Call repository
      final result = await _repository.registerToken(request);
      return AppResult.success(result);
    });
  }
}
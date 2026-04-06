import 'package:teacher_app/data/requests/update_fcm_token_request.dart';
import 'package:teacher_app/data/responses/fcm_token_response.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../services/endpoints.dart';

class FcmTokenRemoteDataSource {


  Future<FcmTokenResponse> registerToken(UpdateFcmTokenRequest request) async {
      appLog("FcmTokenRemoteDataSource: registerToken called with token: ${request.token.substring(0, 20)}...");
      var response = await  ApiService.getInstance().post(EndPoints.updateFcmToken);
      final fcmTokenResponse = FcmTokenResponse.fromJson(response.data!);
      appLog("FcmTokenRemoteDataSource: FCM token registered successfully");
      return fcmTokenResponse;
  }
}
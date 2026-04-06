import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/requests/update_fcm_token_request.dart';
import 'package:teacher_app/data/responses/fcm_token_response.dart';

abstract class FcmTokenRepository {
  Future<FcmTokenResponse> registerToken(UpdateFcmTokenRequest request);
}
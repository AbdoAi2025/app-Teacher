import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/dataSource/fcm_token_remote_data_source.dart';
import 'package:teacher_app/data/repositories/fcm_token/fcm_token_repository.dart';
import 'package:teacher_app/data/requests/update_fcm_token_request.dart';
import 'package:teacher_app/data/responses/fcm_token_response.dart';

class FcmTokenRepositoryImpl extends FcmTokenRepository {
  final FcmTokenRemoteDataSource _remoteDataSource = FcmTokenRemoteDataSource();

  @override
  Future<FcmTokenResponse> registerToken(UpdateFcmTokenRequest request) async {
    return  _remoteDataSource.registerToken(request);
  }
}
import 'package:dio/dio.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/requests/add_student_request.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import 'package:teacher_app/requests/update_student_request.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

import '../../models/check_app_version_model.dart';
import '../../requests/check_app_version_request.dart';
import '../../requests/get_student_details_request.dart';
import '../responses/add_student_response.dart';
import '../responses/check_app_version_response.dart';
import '../responses/get_my_students_responses.dart';
import '../responses/get_student_details_response.dart';

class AppConfigRepository {

  Future<CheckAppVersionModel> checkAppVersion(CheckAppVersionRequest request) async {
      var params = request.toJson();
      Response response = await ApiService.getInstance().get(EndPoints.checkAppVersion , queryParameters: params);
      CheckAppVersionResponse responseResult = CheckAppVersionResponse.fromJson(response.data);
      return CheckAppVersionModel(forceUpdate: responseResult.data?.forceUpdate ?? true);
  }

}

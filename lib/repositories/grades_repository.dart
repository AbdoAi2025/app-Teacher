import 'package:dio/dio.dart';
import 'package:teacher_app/apimodels/grade_api_model.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/models/group.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import 'package:teacher_app/responses/get_grades_list_response.dart';
import 'package:teacher_app/responses/get_my_groups_response.dart';
import 'package:teacher_app/responses/get_my_students_responses.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class GradesRepository {

  Future<List<GradeApiModel>> fetchAllGrades() async {
      Response response = await ApiService.dio.get(EndPoints.getGrades );
      GetGradesListResponse responseResult = GetGradesListResponse.fromJson(response.data);
      return responseResult.data ?? List.empty();
  }
}

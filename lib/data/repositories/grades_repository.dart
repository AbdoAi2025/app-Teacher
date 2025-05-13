import 'package:dio/dio.dart';
import 'package:teacher_app/apimodels/grade_api_model.dart';
import 'package:teacher_app/data/responses/get_grades_list_response.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class GradesRepository {

  Future<List<GradeApiModel>> fetchAllGrades() async {
      Response response = await ApiService.getInstance().get(EndPoints.getGrades );
      GetGradesListResponse responseResult = GetGradesListResponse.fromJson(response.data);
      return responseResult.data ?? List.empty();
  }
}

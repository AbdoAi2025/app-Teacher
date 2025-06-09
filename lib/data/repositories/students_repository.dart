import 'package:dio/dio.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/requests/add_student_request.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import 'package:teacher_app/requests/update_student_request.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

import '../../requests/get_student_details_request.dart';
import '../responses/add_student_response.dart';
import '../responses/get_my_students_responses.dart';
import '../responses/get_student_details_response.dart';

class StudentsRepository {

  Future<List<StudentListItemApiModel>> fetchMyStudent(GetMyStudentsRequest request) async {
      var params = request.toJson();
      Response response = await ApiService.getInstance().get(EndPoints.getMyStudents , queryParameters: params);
      GetMyStudentsResponses responseResult = GetMyStudentsResponses.fromJson(response.data);
      return responseResult.data ?? List.empty();
  }

  Future<AddStudentResponse?> addStudent(AddStudentRequest request) async {
      Response response = await ApiService.getInstance().post(EndPoints.addStudents , data: request.toJson());
      AddStudentResponse responseResult = AddStudentResponse.fromJson(response.data);
      return responseResult;
  }

  Future<AddStudentResponse?> updateStudent(UpdateStudentRequest request) async {
      Response response = await ApiService.getInstance().put(EndPoints.updateStudents , data: request.toJson());
      AddStudentResponse responseResult = AddStudentResponse.fromJson(response.data);
      return responseResult;
  }

  Future<StudentDetailsApiModel?> getStudentDetails(GetStudentDetailsRequest request) async {
    var url = "${EndPoints.getStudentDetails}/${request.id}";
      Response response = await ApiService.getInstance().get(url);
    GetStudentDetailsResponse responseResult = GetStudentDetailsResponse.fromJson(response.data);
      return responseResult.data;
  }

  Future<dynamic>  deleteStudent(String id) async {
    var url = "${EndPoints.deleteStudent}/$id";
    Response response = await ApiService.getInstance().delete(url);
    return response.data;
  }
}

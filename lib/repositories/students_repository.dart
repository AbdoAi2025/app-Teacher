import 'package:dio/dio.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/requests/add_student_request.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import 'package:teacher_app/responses/add_student_response.dart';
import 'package:teacher_app/responses/get_my_students_responses.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class StudentsRepository {

  Future<List<StudentListItemApiModel>> fetchMyStudent(GetMyStudentsRequest request) async {
      var params = request.toJson();
      Response response = await ApiService.dio.get(EndPoints.getMyStudents , queryParameters: params);
      GetMyStudentsResponses responseResult = GetMyStudentsResponses.fromJson(response.data);
      return responseResult.data ?? List.empty();

      //إرجاع قائمة الطلاب (data) أو قائمة فارغة//
    // (List.empty()) إذا لم يكن هناك طلاب.
  }

  Future<AddStudentResponse?> addStudent(AddStudentRequest request) async {
      Response response = await ApiService.dio.post(EndPoints.addStudents , data: request.toJson());
      AddStudentResponse responseResult = AddStudentResponse.fromJson(response.data);
      return responseResult;
  }
}

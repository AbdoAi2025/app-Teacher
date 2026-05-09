import 'package:dio/dio.dart';
import 'package:teacher_app/data/requests/update_teacher_profile_request.dart';
import 'package:teacher_app/data/responses/get_teacher_profile_response.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class TeacherProfileRepository {
  Future<TeacherProfileData> getProfile() async {
    Response response =
        await ApiService.getInstance().get(EndPoints.teacherProfile);
    return GetTeacherProfileResponse.fromJson(response.data).data!;
  }

  Future<TeacherProfileData> updateProfile(
      UpdateTeacherProfileRequest request) async {
    Response response = await ApiService.getInstance()
        .put(EndPoints.teacherProfile, data: request.toJson());
    return GetTeacherProfileResponse.fromJson(response.data).data!;
  }
}
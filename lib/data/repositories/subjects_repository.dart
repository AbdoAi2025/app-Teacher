import 'package:dio/dio.dart';
import 'package:teacher_app/data/responses/get_subjects_response.dart';
import 'package:teacher_app/domain/models/subject_model.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class SubjectsRepository {
  Future<List<SubjectModel>> getSubjects() async {
    Response response = await ApiService.getInstance().get(EndPoints.getSubjects);
    final parsed = GetSubjectsResponse.fromJson(response.data);
    return parsed.data;
  }
}
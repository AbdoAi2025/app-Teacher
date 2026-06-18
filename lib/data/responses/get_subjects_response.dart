import 'package:teacher_app/domain/models/subject_model.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

class GetSubjectsResponse {
  final String? status;
  final String? message;
  final List<SubjectModel> data;

  GetSubjectsResponse({this.status, this.message, required this.data});

  factory GetSubjectsResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    final items = rawList is List
        ? rawList
            .whereType<Map<String, dynamic>>()
            .map((e) => SubjectModel.fromJson(e))
            .toList()
        : <SubjectModel>[];

    return GetSubjectsResponse(
      status: json.tryString('status'),
      message: json.tryString('message'),
      data: items,
    );
  }
}
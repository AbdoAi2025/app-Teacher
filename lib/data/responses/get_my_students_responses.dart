import 'package:teacher_app/apimodels/student_list_item_api_model.dart';

/// data : [{"userId":"string","studentId":"string","studentName":"string","studentPhone":"string","studentParentPhone":"string","gradeNameEn":"string","gradeNameAr":"string","groupId":"string","groupName":"string"}]

class GetMyStudentsResponses {
  GetMyStudentsResponses({
      this.data,});

  GetMyStudentsResponses.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(StudentListItemApiModel.fromJson(v));
      });
    }
  }
  List<StudentListItemApiModel>? data;


}

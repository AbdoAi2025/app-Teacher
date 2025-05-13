import 'package:teacher_app/apimodels/grade_api_model.dart';

/// data : [{"id":1073741824,"nameEn":"string","nameAr":"string"}]

class GetGradesListResponse {
  GetGradesListResponse({
      this.data,});

  GetGradesListResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(GradeApiModel.fromJson(v));
      });
    }
  }
  List<GradeApiModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

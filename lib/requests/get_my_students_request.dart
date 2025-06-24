/// hasGroups : true

class GetMyStudentsRequest {


  GetMyStudentsRequest({
      this.hasGroups,
      this.gradeId,
  });

  GetMyStudentsRequest.fromJson(dynamic json) {
    hasGroups = json['hasGroups'];
    gradeId = json['gradeId'];
  }
  bool? hasGroups;
  String? gradeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hasGroups'] = hasGroups;
    map['gradeId'] = gradeId;
    return map;
  }

}
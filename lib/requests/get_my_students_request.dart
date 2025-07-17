/// hasGroups : true

class GetMyStudentsRequest {


  GetMyStudentsRequest({
      this.hasGroups,
      this.gradeId,
    this.pageSize,
    this.pageIndex,
  });

  GetMyStudentsRequest.fromJson(dynamic json) {
    hasGroups = json['hasGroups'];
    gradeId = json['gradeId'];
  }
  bool? hasGroups;
  String? gradeId;
  int? pageSize;
  int? pageIndex;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hasGroups'] = hasGroups;
    map['gradeId'] = gradeId;
    map['pageSize'] = pageSize;
    map['pageIndex'] = pageIndex;
    return map;
  }

}
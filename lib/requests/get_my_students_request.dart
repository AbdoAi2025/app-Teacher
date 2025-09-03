class GetMyStudentsRequest {

  bool? hasGroups;
  String? gradeId;
  int pageSize;
  int pageIndex;

  GetMyStudentsRequest({
    this.hasGroups,
    this.gradeId,
    this.pageSize = 50,
    this.pageIndex = 0,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (hasGroups != null) {
      map['hasGroups'] = hasGroups;
    }
    if (gradeId != null) {
      map['gradeId'] = gradeId;
    }
    if (pageSize != null) {
      map['pageSize'] = pageSize;
    }

    if (pageIndex != null) {
      map['pageIndex'] = pageIndex;
    }
    return map;
  }
}

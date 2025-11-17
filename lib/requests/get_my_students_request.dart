class GetMyStudentsRequest {

  bool? hasGroups;
  String? gradeId;
  int pageSize;
  int pageIndex;
  String? search;
  String? noInGroupId;

  GetMyStudentsRequest({
    this.hasGroups,
    this.gradeId,
    this.pageSize = 20,
    this.pageIndex = 0,
    this.search,
    this.noInGroupId,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (hasGroups != null) {
      map['hasGroups'] = hasGroups;
    }
    if (gradeId != null) {
      map['gradeId'] = gradeId;
    }

    if (search != null && search!.isNotEmpty) {
      map['searchText'] = search;
    }

    if (noInGroupId != null && noInGroupId!.isNotEmpty) {
      map['noInGroupId'] = noInGroupId;
    }

    map['pageSize'] = pageSize;
    map['pageIndex'] = pageIndex;

    return map;
  }
}

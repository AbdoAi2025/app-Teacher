class GetMyStudentsRequest {

  bool? hasGroups;
  String? gradeId;
  int pageSize;
  int pageIndex;
  String? search;
  String? noInGroupId;
  String? dateFrom;
  String? dateTo;

  GetMyStudentsRequest({
    this.hasGroups,
    this.gradeId,
    this.pageSize = 20,
    this.pageIndex = 0,
    this.search,
    this.noInGroupId,
    this.dateFrom,
    this.dateTo
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

    if (dateFrom != null) {
      map['dateFrom'] = dateFrom;
    }

    if (dateTo != null) {
      map['dateTo'] = dateTo;
    }

    map['pageSize'] = pageSize;
    map['pageIndex'] = pageIndex;

    return map;
  }

  GetMyStudentsRequest copyWith({
    bool? hasGroups,
    String? gradeId,
    int? pageSize,
    int? pageIndex,
    String? search,
    String? noInGroupId,
    String? dateFrom,
    String? dateTo
  }) {
    return GetMyStudentsRequest(
      hasGroups: hasGroups ?? this.hasGroups,
      gradeId: gradeId ?? this.gradeId,
      pageSize: pageSize ?? this.pageSize,
      pageIndex: pageIndex ?? this.pageIndex,
      search: search ?? this.search,
      noInGroupId: noInGroupId ?? this.noInGroupId,
      dateFrom: dateFrom ,
      dateTo: dateTo
    );
  }
}

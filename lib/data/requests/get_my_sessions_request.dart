/// groupId : ""
/// pageIndex : 0
/// pageSize : 20

class GetMySessionsRequest {
  GetMySessionsRequest({
      this.groupId, 
      this.studentId,
      this.pageIndex,
      this.pageSize,});

  GetMySessionsRequest.fromJson(dynamic json) {
    groupId = json['groupId'];
    studentId = json['studentId'];
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];

  }
  String? groupId;
  String? studentId;
  int? pageIndex;
  int? pageSize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (groupId != null) {
      map['groupId'] = groupId;

    }
    if (studentId != null) {
      map['studentId'] = studentId;
    }
    if (pageIndex != null) {
      map['pageIndex'] = pageIndex;
    }
    if (pageSize != null) {
      map['pageSize'] = pageSize;
    }

    return map;
  }

}
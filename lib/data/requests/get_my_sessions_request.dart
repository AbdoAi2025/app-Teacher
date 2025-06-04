/// groupId : ""
/// pageIndex : 0
/// pageSize : 20

class GetMySessionsRequest {
  GetMySessionsRequest({
      this.groupId, 
      this.pageIndex, 
      this.pageSize,});

  GetMySessionsRequest.fromJson(dynamic json) {
    groupId = json['groupId'];
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
  }
  String? groupId;
  int? pageIndex;
  int? pageSize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groupId'] = groupId;
    map['pageIndex'] = pageIndex;
    map['pageSize'] = pageSize;
    return map;
  }

}
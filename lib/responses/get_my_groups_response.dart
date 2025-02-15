/// data : [{"groupId":"string","groupName":"string","groupDay":1073741824,"studentCount":1073741824}]

class GetMyGroupsResponse {
  GetMyGroupsResponse({
      this.data,});

  GetMyGroupsResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// groupId : "string"
/// groupName : "string"
/// groupDay : 1073741824
/// studentCount : 1073741824

class Data {
  Data({
      this.groupId, 
      this.groupName, 
      this.groupDay, 
      this.studentCount,});

  Data.fromJson(dynamic json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
    groupDay = json['groupDay'];
    studentCount = json['studentCount'];
  }
  String? groupId;
  String? groupName;
  int? groupDay;
  int? studentCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    map['groupDay'] = groupDay;
    map['studentCount'] = studentCount;
    return map;
  }

}
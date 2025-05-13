/// groupId : "string"
/// name : "string"
/// studentsIds : ["string"]
/// day : 1073741824
/// timeFrom : "string"
/// timeTo : "string"

class UpdateGroupRequest {
  UpdateGroupRequest({
      this.groupId, 
      this.name, 
      this.studentsIds, 
      this.day, 
      this.timeFrom, 
      this.timeTo,});

  UpdateGroupRequest.fromJson(dynamic json) {
    groupId = json['groupId'];
    name = json['name'];
    studentsIds = json['studentsIds'] != null ? json['studentsIds'].cast<String>() : [];
    day = json['day'];
    timeFrom = json['timeFrom'];
    timeTo = json['timeTo'];
  }
  String? groupId;
  String? name;
  List<String>? studentsIds;
  int? day;
  String? timeFrom;
  String? timeTo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groupId'] = groupId;
    map['name'] = name;
    map['studentsIds'] = studentsIds;
    map['day'] = day;
    map['timeFrom'] = timeFrom;
    map['timeTo'] = timeTo;
    return map;
  }

}
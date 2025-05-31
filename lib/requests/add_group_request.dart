/// name : "string"
/// studentsIds : ["string"]
/// day : 1073741824
/// timeFrom : "string"
/// timeTo : "string"

class AddGroupRequest {
  AddGroupRequest({
      this.name, 
      this.studentsIds, 
      this.day, 
      this.timeFrom, 
      this.timeTo,
      this.gradeId,
  });

  AddGroupRequest.fromJson(dynamic json) {
    name = json['name'];
    studentsIds = json['studentsIds'] != null ? json['studentsIds'].cast<String>() : [];
    day = json['day'];
    timeFrom = json['timeFrom'];
    timeTo = json['timeTo'];
    gradeId = json['gradeId'];
  }
  String? name;
  List<String>? studentsIds;
  int? day;
  String? timeFrom;
  String? timeTo;
  String? gradeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['studentsIds'] = studentsIds;
    map['day'] = day;
    map['timeFrom'] = timeFrom;
    map['timeTo'] = timeTo;
    map['gradeId'] = gradeId;
    return map;
  }

}
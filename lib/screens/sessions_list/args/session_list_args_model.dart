/// groupId : ""

class SessionListArgsModel {

  SessionListArgsModel({
      this.groupId,
      this.studentId,
  });

  SessionListArgsModel.fromJson(dynamic json) {
    groupId = json['groupId'];
    studentId = json['studentId'];
  }
  String? groupId;
  String? studentId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groupId'] = groupId;
    map['studentId'] = studentId;
    return map;
  }

}

class StudentReportsArgsModel {

  StudentReportsArgsModel({     this.studentId,});

  StudentReportsArgsModel.fromJson(dynamic json) {
    studentId = json['studentId'];
  }
  String? groupId;
  String? studentId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentId'] = studentId;
    return map;
  }

}
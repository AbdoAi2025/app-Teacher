

class StartSessionRequest {
  StartSessionRequest({
      this.name, 
      this.groupId,
      this.quizGrade,
  });

  StartSessionRequest.fromJson(dynamic json) {
    name = json['name'];
    groupId = json['groupId'];
    quizGrade = json['quizGrade'];
  }
  String? name;
  String? groupId;
  int? quizGrade;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['groupId'] = groupId;
    map['quizGrade'] = quizGrade;
    return map;
  }

}
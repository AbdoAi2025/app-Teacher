

class StartSessionRequest {
  StartSessionRequest({
      this.name, 
      this.timingId,
      this.quizGrade,
  });

  StartSessionRequest.fromJson(dynamic json) {
    name = json['name'];
    timingId = json['groupId'];
    quizGrade = json['quizGrade'];
  }
  String? name;
  String? timingId;
  int? quizGrade;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['timingId'] = timingId;
    map['quizGrade'] = quizGrade;
    return map;
  }

}
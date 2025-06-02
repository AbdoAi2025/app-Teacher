/// sessionId : "string"
/// activities : [{"studentId":"string","attended":true,"behaviorGood":true,"quizGrade":0.1}]

class UpdateSessionActivitiesRequest {
  UpdateSessionActivitiesRequest({
      this.sessionId, 
      this.activities,});

  UpdateSessionActivitiesRequest.fromJson(dynamic json) {
    sessionId = json['sessionId'];
    if (json['activities'] != null) {
      activities = [];
      json['activities'].forEach((v) {
        activities?.add(StudentActivityItemRequest.fromJson(v));
      });
    }
  }
  String? sessionId;
  List<StudentActivityItemRequest>? activities;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sessionId'] = sessionId;
    if (activities != null) {
      map['activities'] = activities?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// studentId : "string"
/// attended : true
/// behaviorGood : true
/// quizGrade : 0.1

class StudentActivityItemRequest {
  StudentActivityItemRequest({
      this.studentId, 
      this.attended, 
      this.behaviorGood, 
      this.quizGrade,});

  StudentActivityItemRequest.fromJson(dynamic json) {
    studentId = json['studentId'];
    attended = json['attended'];
    behaviorGood = json['behaviorGood'];
    quizGrade = json['quizGrade'];
  }
  String? studentId;
  bool? attended;
  bool? behaviorGood;
  double? quizGrade;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentId'] = studentId;
    map['attended'] = attended;
    map['behaviorGood'] = behaviorGood;
    map['quizGrade'] = quizGrade;
    return map;
  }

}
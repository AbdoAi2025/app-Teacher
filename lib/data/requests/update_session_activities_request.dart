import 'package:teacher_app/enums/student_behavior_enum.dart';

import '../../enums/homework_enum.dart';

/// sessionId : "string"
/// activities : [{"studentId":"string","attended":true,"behaviorGood":true,"quizGrade":0.1}]

class UpdateSessionActivitiesRequest {
  UpdateSessionActivitiesRequest({
    this.sessionId,
    this.activities,
  });

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

// {
// "studentId": "string",
// "attended": true,
// "behaviorStatus": 1073741824,
// "behaviorNotes": "string",
// "homeworkEnum": 1073741824,
// "homeworkNotes": "string",
// "quizGrade": 0.1
// }

class StudentActivityItemRequest {
  StudentActivityItemRequest({
    required this.studentId,
    required this.attended,
    required this.behaviorStatus,
    required this.behaviorNotes,
    required this.homeworkStatus,
    required this.homeworkNotes,
    required this.quizGrade,
  });

  StudentActivityItemRequest.fromJson(dynamic json) {
    studentId = json['studentId'];
    attended = json['attended'];
    behaviorStatus = json['behaviorStatus'];
    behaviorNotes = json['behaviorNotes'];
    homeworkStatus = json['homeworkStatus'];
    homeworkNotes = json['homeworkNotes'];
    quizGrade = json['quizGrade'];
  }

  String? studentId;
  bool? attended;
  StudentBehaviorEnum? behaviorStatus;
  String? behaviorNotes;
  HomeworkEnum? homeworkStatus;
  String? homeworkNotes;
  double? quizGrade;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentId'] = studentId;
    map['attended'] = attended;
    map['behaviorStatus'] = behaviorStatus?.index;
    map['behaviorNotes'] = behaviorNotes;
    map['homeworkStatus'] = homeworkStatus?.index;
    map['homeworkNotes'] = homeworkNotes;
    map['quizGrade'] = quizGrade;
    return map;
  }
}

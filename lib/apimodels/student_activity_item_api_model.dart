
/// sessionId : "7e4eda0d-d310-4b12-bc71-50512a7b2544"
/// sessionName : ""
/// sessionStatus : 1
/// sessionQuizGrade : 0
/// sessionCreatedAt : "2025-09-21T20:32:50.494+00:00"
/// studentId : "f493bad8-cedc-4e4a-8ce5-8f348503db65"
/// studentName : "hamdy student10"
/// studentPhone : "+201063271529"
/// studentParentPhone : "+201063271529"
/// gradeId : 6
/// groupId : "74c95fc3-0115-4ade-9c94-9860fd6928ad"
/// groupName : "group1 for hamdy"
/// activityId : "29110f69-450c-4b57-a570-af1db183ebb4"
/// behaviorStatus : null
/// quizGrade : null
/// behaviorNotes : ""
/// homeworkStatus : 2
/// homeworkNotes : ""
/// attended : true
/// updated : true

class StudentActivityItemApiModel {
  StudentActivityItemApiModel({
    this.sessionId,
    this.sessionName,
    this.sessionStatus,
    this.sessionQuizGrade,
    this.sessionCreatedAt,
    this.studentId,
    this.studentName,
    this.studentPhone,
    this.studentParentPhone,
    this.gradeId,
    this.groupId,
    this.groupName,
    this.activityId,
    this.behaviorStatus,
    this.quizGrade,
    this.behaviorNotes,
    this.homeworkStatus,
    this.homeworkNotes,
    this.attended,
    this.updated,});

  StudentActivityItemApiModel.fromJson(dynamic json) {
    sessionId = json['sessionId'];
    sessionName = json['sessionName'];
    sessionDate = json['sessionDate'];
    sessionStatus = json['sessionStatus'];
    sessionQuizGrade = json['sessionQuizGrade'];
    sessionCreatedAt = json['sessionCreatedAt'];
    studentId = json['studentId'];
    studentName = json['studentName'];
    studentPhone = json['studentPhone'];
    studentParentPhone = json['studentParentPhone'];
    gradeId = json['gradeId'];
    groupId = json['groupId'];
    groupName = json['groupName'];
    activityId = json['activityId'];
    behaviorStatus = json['behaviorStatus'];
    quizGrade = json['quizGrade'];
    behaviorNotes = json['behaviorNotes'];
    homeworkStatus = json['homeworkStatus'];
    homeworkNotes = json['homeworkNotes'];
    attended = json['attended'];
    updated = json['updated'];
  }
  String? sessionId;
  String? sessionName;
  String? sessionDate;
  int? sessionStatus;
  int? sessionQuizGrade;
  String? sessionCreatedAt;
  String? studentId;
  String? studentName;
  String? studentPhone;
  String? studentParentPhone;
  int? gradeId;
  String? groupId;
  String? groupName;
  String? activityId;
  int? behaviorStatus;
  double? quizGrade;
  String? behaviorNotes;
  int? homeworkStatus;
  String? homeworkNotes;
  bool? attended;
  bool? updated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sessionId'] = sessionId;
    map['sessionName'] = sessionName;
    map['sessionStatus'] = sessionStatus;
    map['sessionQuizGrade'] = sessionQuizGrade;
    map['sessionCreatedAt'] = sessionCreatedAt;
    map['studentId'] = studentId;
    map['studentName'] = studentName;
    map['studentPhone'] = studentPhone;
    map['studentParentPhone'] = studentParentPhone;
    map['gradeId'] = gradeId;
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    map['activityId'] = activityId;
    map['behaviorStatus'] = behaviorStatus;
    map['quizGrade'] = quizGrade;
    map['behaviorNotes'] = behaviorNotes;
    map['homeworkStatus'] = homeworkStatus;
    map['homeworkNotes'] = homeworkNotes;
    map['attended'] = attended;
    map['updated'] = updated;
    return map;
  }

}
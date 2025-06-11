/// data : {"sessionId":"4250055f-fe01-4d4a-9c38-8e5a65594f60","sessionStatus":0,"sessionCreatedAt":"2025-06-01T22:31:07.017+00:00","groupId":"95e5ebb8-e51e-46bc-8b8d-8baa5c73b406","groupName":"group1 grade4 ","activities":[{"studentId":"de327f9c-a555-40d8-a74e-e3c9becb5742","studentName":"student4","studentPhone":"2345238745","studentParentPhone":"q34870345","quizGrade":4.0,"attended":true,"behaviorGood":true},{"studentId":"c1dd05d1-ed7e-4fe0-b6db-23d5934a4301","studentName":"student3","studentPhone":"9487098345","studentParentPhone":"04007824","quizGrade":null,"attended":true,"behaviorGood":true},{"studentId":"d92f838c-bf33-47d4-9cca-86fe288a48cf","studentName":"Student2","studentPhone":"","studentParentPhone":"0123123412341234","quizGrade":null,"attended":true,"behaviorGood":true},{"studentId":"e9a79722-557f-4be6-800a-09633581862b","studentName":"student1","studentPhone":"4162394871623498","studentParentPhone":"0112342342432","quizGrade":null,"attended":true,"behaviorGood":true}]}

class GetSessionDetailsResponse {
  GetSessionDetailsResponse({
      this.data,});

  GetSessionDetailsResponse.fromJson(dynamic json) {
    data = json['data'] != null ? SessionDetailsApiModel.fromJson(json['data']) : null;
  }
  SessionDetailsApiModel? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

/// sessionId : "4250055f-fe01-4d4a-9c38-8e5a65594f60"
/// sessionStatus : 0
/// sessionCreatedAt : "2025-06-01T22:31:07.017+00:00"
/// groupId : "95e5ebb8-e51e-46bc-8b8d-8baa5c73b406"
/// groupName : "group1 grade4 "
/// activities : [{"studentId":"de327f9c-a555-40d8-a74e-e3c9becb5742","studentName":"student4","studentPhone":"2345238745","studentParentPhone":"q34870345","quizGrade":4.0,"attended":true,"behaviorGood":true},{"studentId":"c1dd05d1-ed7e-4fe0-b6db-23d5934a4301","studentName":"student3","studentPhone":"9487098345","studentParentPhone":"04007824","quizGrade":null,"attended":true,"behaviorGood":true},{"studentId":"d92f838c-bf33-47d4-9cca-86fe288a48cf","studentName":"Student2","studentPhone":"","studentParentPhone":"0123123412341234","quizGrade":null,"attended":true,"behaviorGood":true},{"studentId":"e9a79722-557f-4be6-800a-09633581862b","studentName":"student1","studentPhone":"4162394871623498","studentParentPhone":"0112342342432","quizGrade":null,"attended":true,"behaviorGood":true}]

class SessionDetailsApiModel {
  SessionDetailsApiModel({
      this.sessionId, 
      this.sessionName,
      this.sessionStatus,
      this.sessionCreatedAt, 
      this.groupId, 
      this.groupName, 
      this.activities,});

  SessionDetailsApiModel.fromJson(dynamic json) {
    sessionId = json['sessionId'];
    sessionName = json['sessionName'];
    sessionStatus = json['sessionStatus'];
    sessionQuizGrade = json['sessionQuizGrade'];
    sessionCreatedAt = json['sessionCreatedAt'];
    groupId = json['groupId'];
    groupName = json['groupName'];
    if (json['activities'] != null) {
      activities = [];
      json['activities'].forEach((v) {
        activities?.add(StudentActivityApiModel.fromJson(v));
      });
    }
  }
  String? sessionId;
  String? sessionName;
  int? sessionStatus;
  int? sessionQuizGrade;
  String? sessionCreatedAt;
  String? groupId;
  String? groupName;
  List<StudentActivityApiModel>? activities;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sessionId'] = sessionId;
    map['sessionName'] = sessionName;
    map['sessionStatus'] = sessionStatus;
    map['sessionQuizGrade'] = sessionQuizGrade;
    map['sessionCreatedAt'] = sessionCreatedAt;
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    if (activities != null) {
      map['activities'] = activities?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// studentId : "de327f9c-a555-40d8-a74e-e3c9becb5742"
/// studentName : "student4"
/// studentPhone : "2345238745"
/// studentParentPhone : "q34870345"
/// quizGrade : 4.0
/// attended : true
/// behaviorGood : true

class StudentActivityApiModel {
  StudentActivityApiModel({
      this.studentId, 
      this.studentName, 
      this.studentPhone, 
      this.studentParentPhone, 
      this.quizGrade, 
      this.attended, 
      this.behaviorGood,});

  StudentActivityApiModel.fromJson(dynamic json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    studentPhone = json['studentPhone'];
    studentParentPhone = json['studentParentPhone'];
    quizGrade = json['quizGrade'];
    attended = json['attended'];
    behaviorGood = json['behaviorGood'];
  }
  String? studentId;
  String? studentName;
  String? studentPhone;
  String? studentParentPhone;
  double? quizGrade;
  bool? attended;
  bool? behaviorGood;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentId'] = studentId;
    map['studentName'] = studentName;
    map['studentPhone'] = studentPhone;
    map['studentParentPhone'] = studentParentPhone;
    map['quizGrade'] = quizGrade;
    map['attended'] = attended;
    map['behaviorGood'] = behaviorGood;
    return map;
  }

}
import '../../apimodels/student_activity_item_api_model.dart';

/// data : [{"sessionId":"7e4eda0d-d310-4b12-bc71-50512a7b2544","sessionName":"","sessionStatus":1,"sessionQuizGrade":0,"sessionCreatedAt":"2025-09-21T20:32:50.494+00:00","studentId":"f493bad8-cedc-4e4a-8ce5-8f348503db65","studentName":"hamdy student10","studentPhone":"+201063271529","studentParentPhone":"+201063271529","gradeId":6,"groupId":"74c95fc3-0115-4ade-9c94-9860fd6928ad","groupName":"group1 for hamdy","activityId":"29110f69-450c-4b57-a570-af1db183ebb4","behaviorStatus":null,"quizGrade":null,"behaviorNotes":"","homeworkStatus":2,"homeworkNotes":"","attended":true,"updated":true},{"sessionId":"f3094720-8505-431b-bf96-d65d1fb850c4","sessionName":"","sessionStatus":0,"sessionQuizGrade":0,"sessionCreatedAt":"2025-09-21T20:40:27.602+00:00","studentId":"f493bad8-cedc-4e4a-8ce5-8f348503db65","studentName":"hamdy student10","studentPhone":"+201063271529","studentParentPhone":"+201063271529","gradeId":6,"groupId":"74c95fc3-0115-4ade-9c94-9860fd6928ad","groupName":"group1 for hamdy","activityId":"4c31b0f7-c4dc-491b-b3bd-bd18f38c8b6c","behaviorStatus":0,"quizGrade":null,"behaviorNotes":"","homeworkStatus":0,"homeworkNotes":"","attended":true,"updated":true},{"sessionId":"7b48f816-d6b2-498d-9fbf-428b3737762f","sessionName":"","sessionStatus":1,"sessionQuizGrade":0,"sessionCreatedAt":"2025-09-07T12:37:48.927+00:00","studentId":"f493bad8-cedc-4e4a-8ce5-8f348503db65","studentName":"hamdy student10","studentPhone":"+201063271529","studentParentPhone":"+201063271529","gradeId":6,"groupId":"74c95fc3-0115-4ade-9c94-9860fd6928ad","groupName":"group1 for hamdy","activityId":"9e36c959-75fa-46a4-bd87-18d0aae0bbbb","behaviorStatus":null,"quizGrade":null,"behaviorNotes":null,"homeworkStatus":null,"homeworkNotes":null,"attended":null,"updated":null},{"sessionId":"8d5ba280-48dd-4423-b8fd-7dab9dd36848","sessionName":"","sessionStatus":1,"sessionQuizGrade":0,"sessionCreatedAt":"2025-09-13T11:22:18.840+00:00","studentId":"f493bad8-cedc-4e4a-8ce5-8f348503db65","studentName":"hamdy student10","studentPhone":"+201063271529","studentParentPhone":"+201063271529","gradeId":6,"groupId":"74c95fc3-0115-4ade-9c94-9860fd6928ad","groupName":"group1 for hamdy","activityId":"fa9bc99d-6c75-4d9d-8e41-53a9038bc7f5","behaviorStatus":null,"quizGrade":null,"behaviorNotes":null,"homeworkStatus":null,"homeworkNotes":null,"attended":null,"updated":null}]
/// status : "success"

class GetStudentActivitiesResponse {
  GetStudentActivitiesResponse({
      this.data, 
      this.status,});

  GetStudentActivitiesResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(StudentActivityItemApiModel.fromJson(v));
      });
    }
    status = json['status'];
  }
  List<StudentActivityItemApiModel>? data;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['status'] = status;
    return map;
  }

}




class EndPoints{

  EndPoints._();

  static const String apiV1 = "/api/v1";
  static const String getMyStudents = "$apiV1/students/myStudents";
  static const String getGrades = "$apiV1/grade/all";
  static const String addStudents = "$apiV1/students/add";
  static const String updateStudents = "$apiV1/students/update";
  static const String getStudentDetails = "$apiV1/students";
  static const String deleteStudent = "$apiV1/students/delete";


  ///api/v1/users/signin
  static const String login = "$apiV1/users/signin";
  static const String logout = "$apiV1/users/signout";
  static const String checkSession = "$apiV1/users/checkSession";

  /*Groups*/
  static const String getMyGroups = "$apiV1/groups/myGroups";
  static const String addGroup = "$apiV1/groups/add";
  static const String updateGroup = "$apiV1/groups/update";
  static const String getGroupDetails = "$apiV1/groups";
  static const String deleteGroup = "$apiV1/groups/delete";

  /*Sessions*/
  static const String startSession = "$apiV1/sessions/startSession";
  static const String endSession = "$apiV1/sessions/endSession";
  static const String getRunningSession = "$apiV1/sessions/getRunningSession";
  static const String getSessionDetails = "$apiV1/sessions";
  static const String deleteSession = "$apiV1/sessions/delete";
  static const String deleteStudentActivity = "$apiV1/activities/delete";
  static const String getStudentActivities = "$apiV1/activities/students";


  static const String updateSessionActivities = "$apiV1/activities/updateStudentsActivities";
  static const String addSessionActivities = "$apiV1/activities/AddStudentsActivities";
  static const String getMySessions = "$apiV1/sessions/getMySessions";
  static const String checkAppVersion = "$apiV1/appConfig/checkAppVersion";



}
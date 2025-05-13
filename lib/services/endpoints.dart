


class EndPoints{

  EndPoints._();

  static const String apiV1 = "/api/v1";
  static const String getMyStudents = "$apiV1/students/myStudents";
  static const String getGrades = "$apiV1/grade/all";
  static const String addStudents = "$apiV1/students/add";
  static const String updateStudents = "$apiV1/students/update";


  ///api/v1/users/signin
  static const String login = "$apiV1/users/signin";
  static const String logout = "$apiV1/users/signout";

  /*Groups*/
  static const String getMyGroups = "$apiV1/groups/myGroups";
  static const String addGroup = "$apiV1/groups/add";
  static const String updateGroup = "$apiV1/groups/update";
  static const String getGroupDetails = "$apiV1/groups";
  static const String deleteGroup = "$apiV1/groups/delete";


}



class EndPoints{

  EndPoints._();

  static const String apiV1 = "/api/v1";
  static const String getMyStudents = "$apiV1/students/myStudents";
  static const String getGrades = "$apiV1/grade/all";
  static const String addStudents = "$apiV1/students/add";
  static const String updateStudents = "$apiV1/students/update";
  static const String upgradeStudents = "$apiV1/students/upgrade";
  static const String getStudentDetails = "$apiV1/students";
  static const String deleteStudent = "$apiV1/students/removeFromTeacher";
  static const String removeStudentGrade = "$apiV1/teachers/student-teacher";
  static const String updateStudentGrade = "$apiV1/teachers/student-teacher";


  ///api/v1/users/signin
  static const String login = "$apiV1/users/signin";
  static const String register = "$apiV1/teachers/add";
  static const String logout = "$apiV1/users/logout";
  static const String checkSession = "$apiV1/users/checkSession";

  /*Groups*/
  static const String getMyGroups = "$apiV1/groups/myGroups";
  static const String addGroup = "$apiV1/groups/add";
  static const String updateGroup = "$apiV1/groups/update";
  static const String upgradeGroup = "$apiV1/groups/teacher/upgradeGroup";
  static const String getGroupDetails = "$apiV1/groups";
  static const String deleteGroup = "$apiV1/groups/delete";
  static const String removeStudentFromGroup = "$apiV1/groups/removeStudentFromGroup";
  static const String addStudentToGroup = "$apiV1/groups/addStudentToGroup";

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
  static const String checkAppVersion = "$apiV1/appVersions/check";

  /*Subscription*/
  static const String getSubscriptionPlans = "$apiV1/subscription/plans";
  static const String getCurrentSubscriptionPlan = "$apiV1/teachers/current-subscription-plan";
  static const String verifyGooglePlayPurchase = "$apiV1/subscription/verify-google-play-purchase";
  static const String initiateSubscription = "$apiV1/payments/subscription/initiate";
  static const String subscribe = "$apiV1/teachers/subscribe";

  /*Payment*/
  static const String verifyPayment = "$apiV1/payments/verify";
  static const String getPaymentMethods = "$apiV1/payment-methods/enabled";

  static String updateFcmToken = "$apiV1/api/v1/fcm/register-token";

  /*OTP*/
  static const String verifyOtp = "$apiV1/otp/verify";
  static const String resendOtp = "$apiV1/otp/resend";

  /*Subjects*/
  static const String getSubjects = "$apiV1/subjects";

  /*Teacher Profile*/
  static const String teacherProfile = "$apiV1/teachers/profile";

  /*Password Reset*/
  static const String forgotPassword = "$apiV1/password/forgot";
  static const String verifyForgotPasswordOtp = "$apiV1/password/verify-otp";
  static const String resetPassword = "$apiV1/password/reset";
  static const String changePassword = "$apiV1/password/change";

}
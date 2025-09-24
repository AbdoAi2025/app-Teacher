import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_routes.dart';
import 'package:teacher_app/screens/report/args/student_report_args.dart';
import 'package:teacher_app/screens/session_details/args/session_details_args_model.dart';
import 'package:teacher_app/screens/sessions_list/args/session_list_args_model.dart';
import 'package:teacher_app/screens/student_details/args/student_details_arg_model.dart';
import 'package:teacher_app/screens/student_edit/args/edit_student_args_model.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import '../screens/group_details/args/group_details_arg_model.dart';
import '../screens/group_details/group_details_controller.dart';
import '../screens/group_edit/args/edit_group_args_model.dart';
import '../screens/student_reports/args/student_reports_args_model.dart';
import 'my_route_observer.dart';

class AppNavigator {

  AppNavigator._();


  static navigateToHome() {
    Get.offAllNamed(AppRoutes.bottomBar);
  }

  static navigateToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  static Future<dynamic>? navigateToAddStudent() {
    return Get.toNamed(AppRoutes.addStudent);
  }

  static  navigateToCreateGroup() {
     Get.toNamed(AppRoutes.createGroup);
  }

  static  navigateToGroupDetails(GroupDetailsArgModel model) {
    navigateOrBackIfExistToNamed(AppRoutes.groupDetails , arguments: model);
    if (Get.isRegistered<GroupDetailsController>()) {
      Get.find<GroupDetailsController>().updateGroup(model);
    }
  }

  static Future<dynamic> navigateToEditGroup(EditGroupArgsModel model) async {
    return await Get.toNamed(AppRoutes.editGroup , arguments: model);
  }

  static Future<dynamic>? navigateToEditStudent(EditStudentArgsModel args) {
    return Get.toNamed(AppRoutes.editStudent , arguments: args);
  }

  static Future<dynamic> navigateToCreateEditGroup(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.createEditGroup);
  }

  static void navigateToStudentDetails(StudentDetailsArgModel studentDetailsArgModel) {
    navigateOrBackIfExistToNamed(AppRoutes.studentDetails , arguments: studentDetailsArgModel);
  }

  /*Sessions*/
  static void navigateToSessionDetails(SessionDetailsArgsModel args) {
    navigateOrBackIfExistToNamed(AppRoutes.sessionDetails , arguments: args);
  }

  static void navigateToSessionsList(SessionListArgsModel args) {
    Get.toNamed(AppRoutes.sessionsList , arguments: args);
  }

  static void navigateToStudentReports(StudentReportsArgsModel args) {
    Get.toNamed(AppRoutes.studentReports , arguments: args);
  }

  static void navigateToStudentReport(StudentReportArgs args) {
    Get.toNamed(AppRoutes.studentReport , arguments: args);
  }

  static void back() {
    Get.back();
  }

  static bool isInStackOrCurrent(String routeName) {
    if (Get.currentRoute == routeName) return true;
    return routeExistsInBackstack(routeName);
  }

  static bool routeExistsInBackstack(String routeName) {


    bool exists = MyRouteObserver.history.any((r) => r.settings.name == routeName);
    return exists;


    // bool exists = false;
    //
    // // Walk through the navigator stack
    // Navigator.of(Get.context!).popUntil((route) {
    //   if (route.settings.name == routeName) {
    //     exists = true;
    //     return true; // stop popping here
    //   }
    //   return true; // keep popping
    // });
    //
    //
    // // Navigator.of(Get.context!).popUntil((route) {
    // //   if (route.settings.name == routeName) {
    // //     exists = true;
    // //   }
    // //   return true; // don't actually pop, just check
    // // });
    //  return exists;
  }

  static void navigateOrBackIfExistToNamed(String routeName, {dynamic arguments}) {
    if (isInStackOrCurrent(routeName)) {
      Get.until((route) => route.settings.name == routeName);
    } else {
      Get.toNamed(routeName, arguments: arguments);
    }
  }

}

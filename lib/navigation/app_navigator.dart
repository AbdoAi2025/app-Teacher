import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_routes.dart';
import 'package:teacher_app/screens/student_details/args/student_details_arg_model.dart';
import 'package:teacher_app/screens/student_edit/args/edit_student_args_model.dart';
import '../screens/group_details/args/group_details_arg_model.dart';
import '../screens/group_edit/args/edit_group_args_model.dart';

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

  static  navigateToCreateGroup(BuildContext context) {
     Get.toNamed(AppRoutes.createGroup);
  }

  static  navigateToGroupDetails(GroupDetailsArgModel model) {
     Get.toNamed(AppRoutes.groupDetails , arguments: model);
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
    Get.toNamed(AppRoutes.studentDetails , arguments: studentDetailsArgModel);
  }

}

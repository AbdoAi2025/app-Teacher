import 'package:flutter/material.dart';
import 'package:teacher_app/navigation/app_routes.dart';

class AppNavigator {


  static Future<dynamic> navigateToAddStudent(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.addStudent);
  }

  static Future<dynamic> navigateToCreateGroup(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.createGroup);
  }

  static Future<dynamic> navigateToGroupDetails(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.groupDetails);
  }

  static Future<dynamic> navigateToEditStudent(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.editStudent);
  }

  static Future<dynamic> navigateToCreateEditGroup(BuildContext context) {
    return Navigator.pushNamed(context, AppRoutes.createEditGroup);
  }

}

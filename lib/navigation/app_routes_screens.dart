import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_routes.dart';
import 'package:teacher_app/screens/bottom_bar/bottom_bar_screen.dart';
import 'package:teacher_app/screens/create_group/create_group_screen.dart';
import 'package:teacher_app/screens/session_details/session_details_screen.dart';
import 'package:teacher_app/screens/sessions_list/session_list_screen.dart';
import 'package:teacher_app/screens/student_add/add_student_screen.dart';
import 'package:teacher_app/screens/splash/SplashScreen.dart';
import 'package:teacher_app/screens/login/login_screen.dart';
import '../screens/group_details/group_details_screen.dart';
import '../screens/group_edit/edit_group_screen.dart';
import '../screens/student_details/student_details_screen.dart';
import '../screens/student_edit/edit_student_screen.dart';


const int transitionDuration = 600;


List<GetPage> appRoutes() => [
  _getPage(AppRoutes.root, SplashScreen() , duration: Duration()),
  _getPage(AppRoutes.login, LoginScreen()),
  _getPage(AppRoutes.bottomBar, BottomBarScreen()),
  _getPage(AppRoutes.createGroup, CreateGroupScreen()),
  _getPage(AppRoutes.groupDetails, GroupDetailsScreen()),
  _getPage(AppRoutes.editGroup, EditGroupScreen()),
  _getPage(AppRoutes.addStudent, AddStudentScreen()),
  _getPage(AppRoutes.editStudent, EditStudentScreen()),
  _getPage(AppRoutes.studentDetails, StudentDetailsScreen()),
  _getPage(AppRoutes.sessionDetails, SessionDetailsScreen()),
  _getPage(AppRoutes.sessionsList, SessionListScreen()),

];


_getPage(String path , Widget widget , {Transition? transition , Duration? duration , bool popGesture = true}) => GetPage(
  name: path,
  page: () => widget,
  transition: transition ?? Transition.cupertino,
  transitionDuration: duration ?? const Duration(milliseconds: transitionDuration),
  popGesture: popGesture,
);

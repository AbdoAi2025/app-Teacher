import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:teacher_app/navigation/app_routes.dart';
import 'package:teacher_app/screens/edit_group/edit_group_screen.dart';
import 'package:teacher_app/screens/splash/SplashScreen.dart';
import 'package:teacher_app/screens/create_group/create_group_screen.dart';
import 'package:teacher_app/screens/home_screen.dart';
import 'package:teacher_app/screens/login/login_screen.dart';

import '../screens/group_details/group_details_screen.dart';


const int transitionDuration = 600;


List<GetPage> appRoutes() => [
  _getPage(AppRoutes.root, SplashScreen() , duration: Duration()),
  _getPage(AppRoutes.login, LoginScreen()),
  _getPage(AppRoutes.home, HomeScreen()),
  _getPage(AppRoutes.createGroup, CreateGroupScreen()),
  _getPage(AppRoutes.groupDetails, GroupDetailsScreen()),
  _getPage(AppRoutes.editGroup, EditGroupScreen()),

];


_getPage(String path , Widget widget , {Transition? transition , Duration? duration , bool popGesture = true}) => GetPage(
  name: path,
  page: () => widget,
  transition: transition ?? Transition.cupertino,
  transitionDuration: duration ?? const Duration(milliseconds: transitionDuration),
  popGesture: popGesture,
);

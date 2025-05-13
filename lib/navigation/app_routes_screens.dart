import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:teacher_app/navigation/app_routes.dart';
import 'package:teacher_app/screens/splash/SplashScreen.dart';
import 'package:teacher_app/screens/add_student_screen.dart';
import 'package:teacher_app/screens/create_edit_group_screen.dart';
import 'package:teacher_app/screens/create_group_screen.dart';
import 'package:teacher_app/screens/edit_student_screen.dart';
import 'package:teacher_app/screens/group_details_screen.dart';
import 'package:teacher_app/screens/groups_screen.dart';
import 'package:teacher_app/screens/home_screen.dart';
import 'package:teacher_app/screens/login/login_screen.dart';


const int transitionDuration = 600;


class AppRoutesScreens {

  static Route<dynamic> get(RouteSettings settings) {
    return MaterialPageRoute(builder: (BuildContext context){
      var route = settings.name;
      switch(route){
        case AppRoutes.addStudent: return AddStudentScreen();
        case AppRoutes.createGroup: return CreateGroupScreen();
        case AppRoutes.createEditGroup: return CreateEditGroupScreen();
        case AppRoutes.home: return HomeScreen();
        case AppRoutes.groups: return GroupsScreen();
      // case AppRoutes.editStudent: return EditStudentScreen(student: ,);
      }
      return Container();

    });
  }




  static _getWidget(String? route) {
    switch (route) {
      case AppRoutes.addStudent:
        return AddStudentScreen();
      case AppRoutes.createGroup:
        return CreateGroupScreen();
      case AppRoutes.createEditGroup:
        return CreateEditGroupScreen();
      case AppRoutes.home:
        return HomeScreen();
      case AppRoutes.groups:
        return GroupsScreen();
      // case AppRoutes.editStudent: return EditStudentScreen(student: ,);
    }
  }
}

List<GetPage> appRoutes() => [
  _getPage(AppRoutes.root, SplashScreen() , duration: Duration()),
  _getPage(AppRoutes.login, LoginScreen()),
  _getPage(AppRoutes.home, HomeScreen()),

];


_getPage(String path , Widget widget , {Transition? transition , Duration? duration , bool popGesture = true}) => GetPage(
  name: path,
  page: () => widget,
  transition: transition ?? Transition.cupertino,
  transitionDuration: duration ?? const Duration(milliseconds: transitionDuration),
  popGesture: popGesture,
);

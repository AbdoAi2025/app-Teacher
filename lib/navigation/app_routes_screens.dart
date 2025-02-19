import 'package:flutter/material.dart';
import 'package:teacher_app/navigation/app_routes.dart';
import 'package:teacher_app/screens/add_student_screen.dart';
import 'package:teacher_app/screens/create_edit_group_screen.dart';
import 'package:teacher_app/screens/create_group_screen.dart';
import 'package:teacher_app/screens/edit_student_screen.dart';
import 'package:teacher_app/screens/group_details_screen.dart';
import 'package:teacher_app/screens/groups_screen.dart';
import 'package:teacher_app/screens/home_screen.dart';

class AppRoutesScreens {


  static MaterialPageRoute get(RouteSettings settings) {

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
}

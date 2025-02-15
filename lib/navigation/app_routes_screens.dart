import 'package:flutter/material.dart';
import 'package:teacher_app/navigation/app_routes.dart';
import 'package:teacher_app/screens/add_student_screen.dart';
import 'package:teacher_app/screens/create_edit_group_screen.dart';
import 'package:teacher_app/screens/create_group_screen.dart';

class AppRoutesScreens {


  static MaterialPageRoute get(RouteSettings settings) {

    return MaterialPageRoute(builder: (BuildContext context){
      var route = settings.name;
      switch(route){
        case AppRoutes.addStudent: return AddStudentScreen();
        case AppRoutes.createGroup: return CreateEditGroupScreen();
      }
      return Container();

    });
  }
}

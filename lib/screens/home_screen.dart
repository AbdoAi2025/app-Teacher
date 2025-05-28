import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/create_group/create_group_screen.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'groups/groups_screen.dart';
import 'students_screen.dart';
import 'create_edit_group_screen.dart';
import 'group_details_screen.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../bloc/groups/groups_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        onPressed: () {
          AppNavigator.navigateToCreateGroup(context);
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups".tr),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Students"),
          BottomNavigationBarItem(icon: Icon(Icons.account_box_rounded), label: "Profile".tr),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _groupsScreen() => GroupsScreen();

  _studentsScreen() => Center(
    child: AppTextWidget("_studentsScreen"),
  );

  getBody() {
    switch (_currentIndex) {
      case 1:
        return _studentsScreen();
      case 2:
        return _profileScreen();
    }
    return _groupsScreen();
  }

  _profileScreen() {
   return AppTextWidget("_profileScreen");
  }

}

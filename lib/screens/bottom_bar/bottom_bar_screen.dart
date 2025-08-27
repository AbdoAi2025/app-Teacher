import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/ads/AdsManager.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import '../../appSetting/appSetting.dart';
import '../groups/groups_screen.dart';
import '../home/home_screen.dart';
import '../settings/settings_screen.dart';
import '../students_list/students_screen.dart';

class BottomBarScreen extends StatefulWidget {

  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    appLog("_BottomBarScreenState build");
    return ValueListenableBuilder(
        valueListenable: getAppSettingNotifier(),
      builder: (BuildContext context, value, Widget? child) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(child: getBody()),
              AdsManager.homeBanner()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: _onItemTapped,
            selectedItemColor: AppColors.appMainColor,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home".tr),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups".tr),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Students".tr),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings".tr),
            ],
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _homeScreen() => HomeScreen();

  _groupsScreen() => GroupsScreen();

  _studentsScreen() => StudentsScreen();

  Widget getBody() {
    switch (_currentIndex) {
      case 1:
        return _groupsScreen();
      case 2:
        return _studentsScreen();
      case 3:
        return _settingsScreen();
    }
    return _homeScreen();
  }

  _settingsScreen() {
    return SettingsScreen();
  }
}

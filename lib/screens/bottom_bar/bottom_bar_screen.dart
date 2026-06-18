import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/dialogs/user_not_subscribed_dialog.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/lifecycle_widget.dart';
import '../../appSetting/appSetting.dart';
import '../groups/groups_screen.dart';
import '../home/home_screen.dart';
import '../settings/settings_screen.dart';
import '../students_list/students_screen.dart';
import 'bottom_bar_controller.dart';
import '../../domain/states/current_subscription_plan_state.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class BottomBarScreen extends StatefulWidget {

  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends LifecycleWidgetState<BottomBarScreen> {

  int _currentIndex = 0;
  late final BottomBarController controller = Get.put(BottomBarController());

  CurrentSubscriptionPlanState? currentSubscriptionState;

  @override
  void initState() {
    super.initState();
    appLog("_BottomBarScreenState initState");
    // Listen to subscription state changes using the sealed class
    ever(controller.subscriptionManager.stateRx, (state) {
      currentSubscriptionState = state;
    });
  }

  @override
  void dispose() {
    // GetX automatically handles disposal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLog("_BottomBarScreenState build");
    return ValueListenableBuilder(
        valueListenable: getAppSettingNotifier(),
      builder: (BuildContext context, value, Widget? child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: getBody(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: _onItemTapped,
            selectedItemColor: AppColors.appMainColor,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: AppStringsKeys.home.tr),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: AppStringsKeys.groups.tr),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: AppStringsKeys.students.tr),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: AppStringsKeys.settings.tr),
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

  @override
  Future<void> onResumedNavigatedBack() async {
    appLog("BottomBarScreen: onResumedNavigatedBack");
  }

  @override
  void onFirstTimeOpened() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      _handleSubscriptionState();
    },);
  }

  @override
  void onPausedNavigatedAway() {
    appLog("BottomBarScreen: onPausedNavigatedAway");
  }

  Future<void> _handleSubscriptionState() async {
    var state = currentSubscriptionState ?? await controller.subscriptionManager.getCurrentSubscriptionState();
    switch (state) {
      case CurrentSubscriptionPlanInitial():
        appLog("BottomBarScreen: Subscription state - Initial");
        break;
      case CurrentSubscriptionPlanLoading():
        appLog("BottomBarScreen: Subscription state - Loading");
        break;
      case CurrentSubscriptionPlanSuccess(data: final subscription):
        appLog("BottomBarScreen: Subscription state - Success: ${subscription.planName}");
        UserNotSubscribedDialog.handleSubscriptionState(state);
        break;
      case CurrentSubscriptionPlanError(message: final error):
        appLog("BottomBarScreen: Subscription state - Error: $error");
        // Handle subscription error state
        // Could show snackbar or handle error UI here
        break;
    }
  }



}

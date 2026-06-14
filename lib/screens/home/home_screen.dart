import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/home/home_controller.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'package:teacher_app/widgets/sessions/running_session_item_widget.dart';

import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/groups/group_item_widget.dart';
import '../../widgets/paymob_simple_widget.dart';
import '../groups/groups_state.dart';
import 'states/home_state.dart';
import 'states/running_session_item_ui_state.dart';
import 'states/running_sessions_state.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DateTime? _lastPressed;

  HomeController controller = Get.put(HomeController());

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastPressed == null ||
        now.difference(_lastPressed!) > const Duration(seconds: 2)) {
      _lastPressed = now;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Press back again to exit")),
      );

      return false; // 🚫 don’t exit yet
    }
    return true; // ✅ exit on second back
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // disable default pop on root
      onPopInvoked: (didPop) async {
        if (didPop) return; // already popped, do nothing

        final shouldExit = await _onWillPop();
        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        // appBar: AppToolbarWidget.appBar(title: AppStringsKeys.home.tr, hasLeading: false),
        body: SafeArea(
            child: Column(
          children: [
            _name(),
            Expanded(child: _content()),
          ],
        )),
      ),
    );
  }

  Widget _content() {
    return RefreshIndicator(
      onRefresh: () async {
        controller.onRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // <-- key line
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: _contentState(),
        ),
      ),
    );
  }

  Widget _contentState() {
    return  Obx((){
      var state = controller.homeState.value;
      if(state is HomeStateLoading){
        return Center(child: LoadingWidget());
      }
      return Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [_runningSession(), _todayGroups()],
      );
    });
  }

  _runningSession() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 15,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _runningTitle(),
          ),
          Obx(() {
            var state = controller.runningState.value;

            appLog("home screen _runningSession state:$state");

            if (state is RunningSessionsStateLoading) {
              return Center(child: LoadingWidget());
            }

            List<RunningSessionItemUiState> uiStates = [];

            if (state is RunningSessionsStateError) {
              uiStates = [];
            }

            if (state is RunningSessionsStateSuccess) {
              uiStates = state.uiState;
            }

            return _runningSessions(uiStates);
          }),
        ],
      ),
    );
  }

  Widget _runningTitle() => AppTextWidget(
        AppStringsKeys.runningSession.tr,
        style: AppTextStyle.title,
      );

  Widget _todayGroups() {
    return Obx(() {
      var state = controller.todayGroupsState.value;
      switch (state) {
        case GroupsStateLoading():
          return LoadingWidget();
        case GroupsStateSuccess():
          return _todayGroupsList(state.uiStates);
        default:
          return _noTodayGroups();
      }
    });
  }

  _runningSessions(List<RunningSessionItemUiState> uiStates) {

    // return _runningSessionEmpty();
    if (uiStates.isEmpty) {
      return _runningSessionEmpty();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...uiStates.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Container(
                margin: EdgeInsetsDirectional.only(
                    start: index == 0 ? 20 : 10,
                    end: index == uiStates.length - 1 ? 20 : 0),
                width: uiStates.length == 1 ? Get.width - 40 : Get.width * .7,
                padding: EdgeInsets.all(15),
                decoration: AppBackgroundStyle.backgroundWithShadow(),
                child: _runningSessionItem(item),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _runningSessionItem(RunningSessionItemUiState item) {
    return RunningSessionItemWidget(
      item: item,
      onSessionEnded: () {
        controller.onRefresh();
      },
    );
  }

  _runningSessionEmpty() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: AppBackgroundStyle.backgroundWithShadow(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.appMainColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_circle_outline_rounded,
              size: 38,
              color: AppColors.appMainColor,
            ),
          ),
          AppTextWidget(
            AppStringsKeys.noRunningSessions.tr,
            style: AppTextStyle.title.copyWith(color: AppColors.appMainColor),
            textAlign: TextAlign.center,
          ),
          AppTextWidget(
            AppStringsKeys.allSessionsAreCurrentlyInactive.tr,
            style: AppTextStyle.subTitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _todayGroupsList(List<GroupItemUiState> uiStates) {

    if (uiStates.isEmpty) {
      return _noTodayGroups();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget(AppStringsKeys.todayGroups.tr , style: AppTextStyle.title,),
          ...uiStates.map((e) => GroupItemWidget(uiState: e,))
        ],
      ),
    );
  }

  Widget _noTodayGroups() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      // decoration: BoxDecoration(
      //   color: AppColors.white,
      //   borderRadius: BorderRadius.circular(16),
      //   border: Border.all(color: AppColors.color_DBD5CC.withValues(alpha: 0.5)),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withValues(alpha: 0.04),
      //       blurRadius: 10,
      //       offset: const Offset(0, 4),
      //     ),
      //   ],
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.appMainColor.withValues(alpha: 0.07),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.groups_2_outlined,
              size: 40,
              color: AppColors.appMainColor,
            ),
          ),
          Column(
            spacing: 6,
            children: [
              AppTextWidget(
                AppStringsKeys.noGroupsToday.tr,
                style: AppTextStyle.title.copyWith(color: AppColors.appMainColor),
                textAlign: TextAlign.center,
              ),
              AppTextWidget(
                AppStringsKeys.youHaveNoSessionsScheduledForToday.tr,
                style: AppTextStyle.subTitle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          PrimaryButtonWidget(
            text: AppStringsKeys.createNewGroups.tr,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            onClick: () => AppNavigator.navigateToCreateGroup(),
          ),
        ],
      ),
    );
  }

  _name() {
   return Obx(() {
      var state = controller.profileInfo.value;

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
                child: AppTextWidget(
              "${state?.gender.isFemale == true ? AppStringsKeys.heyMs.tr : AppStringsKeys.heyMr.tr} ${state?.name ?? ""}" ,
              style: AppTextStyle.title.copyWith(color: AppColors.appMainColor),
            )),
          ],
        ),
      );
    });
  }

  void onLogout() {

    showConfirmationMessage(AppStringsKeys.areYouSureToLogout.tr, (){
      controller.logout();
      AppNavigator.navigateToLogin();
    });
  }


}

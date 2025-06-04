import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/home/home_controller.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/empty_view_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'package:teacher_app/widgets/sessions/running_session_item_widget.dart';

import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/groups/group_item_widget.dart';
import '../groups/groups_state.dart';
import 'states/home_state.dart';
import 'states/running_session_item_ui_state.dart';
import 'states/running_sessions_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppToolbarWidget.appBar("Home".tr, hasLeading: false),
      body: SafeArea(
          child: Column(
        children: [
          _nameAndLogout(),
          Expanded(child: _content()),
        ],
      )),
    );
  }

  Widget _content() {
    return RefreshIndicator(
      onRefresh: () async {
        controller.onRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // <-- key line
        child: _contentState(),
      ),
    );
  }

  _contentState() {
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
      height: 250,
      // padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _runningTitle(),
          ),
          Expanded(child: Obx(() {
            var state = controller.runningState.value;

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
          }))
        ],
      ),
    );
  }

  Widget _runningTitle() => AppTextWidget(
        "Running Session".tr,
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

    return ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var item = uiStates[index];
          return Container(
              margin: EdgeInsetsDirectional.only(
                  start: index == 0 ? 20 : 0,
                  end: (index == uiStates.length - 1) ? 20 : 0),
              width: uiStates.length == 1 ? Get.width - 40 : Get.width * .7,
              padding: EdgeInsets.all(15),
              decoration: AppBackgroundStyle.backgroundWithShadow(),
              child: _runningSessionItem(item));
        },
        separatorBuilder: (context, index) => SizedBox(
              width: 10,
            ),
        itemCount: uiStates.length);
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
        height: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(15),
        decoration: AppBackgroundStyle.backgroundWithShadow(),
        child: EmptyViewWidget(message: "No Running Sessions Found".tr));
  }

  Widget _todayGroupsList(List<StudentItemUiState> uiStates) {
    if (uiStates.isEmpty) {
      return _noTodayGroups();
    }

    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => GroupItemWidget(
              uiState: uiStates[index],
            ),
        separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
        itemCount: uiStates.length);
  }

  Widget _noTodayGroups() {
    return Column(
      spacing: 20,
      children: [
        EmptyViewWidget(message: "No Doday Groups".tr),
        PrimaryButtonWidget(
            text: "Create New Groups".tr,
            onClick: () {
              AppNavigator.navigateToCreateGroup();
            })
      ],
    );
  }

  _nameAndLogout() {
   return Obx(() {
      var state = controller.profileInfo.value;

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
                child: AppTextWidget(
              "Hey, ${state?.name ?? ""}" ,
              style: AppTextStyle.title.copyWith(color: AppColors.appMainColor),
            )),
            InkWell(
                onTap: () {
                  onLogout();
                },
                child: Icon(Icons.logout))
          ],
        ),
      );
    });
  }

  void onLogout() {
    controller.logout();
    AppNavigator.navigateToLogin();
  }


}

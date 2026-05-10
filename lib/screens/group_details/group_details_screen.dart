import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_group_details_response.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/group_details/states/group_details_ui_state.dart';
import 'package:teacher_app/screens/home/states/running_session_item_ui_state.dart';
import 'package:teacher_app/screens/student_details/args/student_details_arg_model.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/day_utils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/app_visibility_widget.dart';
import 'package:teacher_app/widgets/day_info_chip_widget.dart';
import 'package:teacher_app/widgets/day_with_icon_widget.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:teacher_app/widgets/edit_icon_widget.dart';
import 'package:teacher_app/widgets/forward_arrow_widget.dart';
import 'package:teacher_app/widgets/grade_with_icon_widget.dart';
import 'package:teacher_app/widgets/lifecycle_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/sessions/running_session_item_widget.dart';
import 'package:teacher_app/widgets/sessions/start_session_button_widget.dart';
import '../../bottomsheets/setting_bottom_sheet.dart';
import '../../themes/txt_styles.dart';
import '../../utils/LogUtils.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/groups/states/group_student_item_ui_state.dart';
import '../../widgets/students/students_group_list_search_widget.dart';
import '../../widgets/students/students_group_list_widget.dart';
import '../group_edit/args/edit_group_args_model.dart';
import '../group_upgrade/upgrade_group_screen.dart';
import '../sessions_list/args/session_list_args_model.dart';
import 'group_details_controller.dart';
import 'states/group_details_state.dart';
import 'states/group_details_student_item_ui_state.dart';

class GroupDetailsScreen extends StatefulWidget {
  const GroupDetailsScreen({super.key});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends LifecycleWidgetState<GroupDetailsScreen> {

  final GroupDetailsController controller = Get.put(GroupDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppToolbarWidget.appBar(title: "Group Details".tr, actions: [
          _settingsIcon(),
        ]),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: RefreshIndicator(
              onRefresh: () async {
                controller.reload();
              },
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _content())),
        ));
  }

  Widget _content() {
    return Obx(() {
      var state = controller.state.value;
      switch (state) {
        case GroupDetailsStateLoading():
          return _showLoading();
        case GroupDetailsStateInvalidArgs():
          return Center(child: Text("Invalid Args"));
        case GroupDetailsStateSuccess():
          return _groupDetails(state);
        case GroupDetailsStateError():
          return Center(child: Text(state.exception.toString()));
      }
    });
  }

  _showLoading() {
    return Center(child: LoadingWidget());
  }

  _groupDetails(GroupDetailsStateSuccess state) {
    var uiState = state.uiState;
    return Column(
      spacing: 20,
      children: [
        _sessionSection(uiState),
        _groupInfoSection(uiState),
        _studentsSection(uiState),
        _viewSessionsSection(uiState),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget _groupInfoSection(GroupDetailsUiState uiState) {
    var content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _groupName(uiState.groupName),
          ...uiState.timings.map((t) => _groupDay(
              "${AppDateUtils.getDayName(t.day ?? -1).tr} : ${t.timeFrom ?? ''} - ${t.timeTo ?? ''}")),
          _grade(uiState.grade),
        ],
      ),
    );

    return _sectionLabelValue("Group Info".tr, content);
  }

  Widget _studentsSection(GroupDetailsUiState uiState) {
    var students = uiState.students;
    var count = 4;
    final firstFive = students.take(count).toList();

    return _sectionLabelValue(
      "Students".tr,
      _studentsList(firstFive),
      students.length > count ? _showAllStudents(students) : null,
      false,
    );
  }

  _groupName(String groupName) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Group Name".tr),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 10),
          child: _value(groupName),
        ),
      ],
    );
  }

  _groupDay(String day) {
    return DayInfoChipWidget(text: day);
  }

  _grade(String grade) {
    return GradeWithIconWidget(grade);
  }

  Widget _label(String text) => AppTextWidget(text, style: AppTextStyle.label);

  Widget _value(String text) => AppTextWidget(text, style: AppTextStyle.value);

  Widget _sectionLabelValue(String label, Widget content, [Widget? endIcon , bool hasBackground = true]) {
    return Container(
      width: double.infinity,
      decoration: hasBackground ? AppBackgroundStyle.backgroundWithShadow() : null,
      padding: hasBackground ? EdgeInsets.all(10): EdgeInsets.zero,
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _label(label)),
              if (endIcon != null) endIcon
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: SizedBox(width: double.infinity, child: content),
          ),
        ],
      ),
    );
  }

  Widget _studentsList(List<GroupDetailsStudentItemUiState> student) {
    return StudentsGroupListWidget(
      students: student,
      onStudentItemClick: onStudentItemClick,
    );
  }


  _settingsIcon() {
    return Obx(() {
      var state = controller.state.value;
      if (state is GroupDetailsStateSuccess) {
        return IconButton(
          icon: Icon(Icons.settings, color: AppColors.appMainColor),
          onPressed: () => _showSettingsBottomSheet(state.uiState),
        );
      }
      return Container();
    });
  }

  void _showSettingsBottomSheet(GroupDetailsUiState uiState) {
    SettingBottomSheet.show(
        context: context,
        itemsModels : [
          SettingItemModel.editItem(() {
            onEditClick();
          }),
          SettingItemModel.upgradeItem(() {
            onUpgradeClick();
          }),
          SettingItemModel.deleteItem(() {
            onDeleteClick(uiState);
          }),
        ]
    );
  }

  onEditClick() async {
    var uiState = controller.getGroupDetailsUiState();
    var args = EditGroupArgsModel(
        groupId: uiState?.groupId ?? "",
        groupName: uiState?.groupName ?? "",
        gradeName: uiState?.grade ?? "",
        gradeId: uiState?.gradeId ?? 0,
        timings: uiState?.timings ?? [],
        students: uiState?.students ?? List.empty());

    var result = await AppNavigator.navigateToEditGroup(args);

    // if (result == true) {
    //   controller.reload();
    // }
  }

  onUpgradeClick() async {
    var uiState = controller.getGroupDetailsUiState();
    var args = EditGroupArgsModel(
        groupId: uiState?.groupId ?? "",
        groupName: uiState?.groupName ?? "",
        gradeName: uiState?.grade ?? "",
        gradeId: uiState?.gradeId ?? 0,
        timings: uiState?.timings ?? [],
        students: uiState?.students ?? List.empty());

    var result = await AppNavigator.navigateToUpgradeGroup(args);

    if (result == true) {
      controller.reload();
    }
  }

  onDeleteClick(GroupDetailsUiState uiState) {
    showConfirmationMessage(
        "${"Are you sure to delete ?".tr} ${uiState.groupName}", () {
      showDialogLoading();
      controller.deleteGroup(uiState).listen(
        (event) {
          hideDialogLoading();
          if (event.isSuccess) {
            Get.back();
            return;
          }
          if (event.isError) {
            showErrorMessage(event.error?.toString());
          }
        },
      );
    });
  }

  _divider() => Divider(
        height: 0,
      );

  void onStudentItemClick(GroupStudentItemUiState uiState) {
    AppNavigator.navigateToStudentDetails(
        StudentDetailsArgModel(id: uiState.id));
  }

  _sessionSection(GroupDetailsUiState uiState) {
    var activeSession = uiState.activeSession;
    appLog("GroupDetailsScreen _sessionSection activeSession:$activeSession");
    return Container(
      width: double.infinity,
      decoration: AppBackgroundStyle.backgroundWithShadow(),
      padding: EdgeInsets.all(15),
      child: activeSession != null
          ? _activeSession(uiState, activeSession)
          : _noActiveSession(uiState),
    );
  }

  _activeSession(
      GroupDetailsUiState uiState, ActiveSessionApiModel activeSession) {
    return RunningSessionItemWidget(
      item: RunningSessionItemUiState(
          id: activeSession.sessionId ?? "",
          date: AppDateUtils.parseStringToDateTime(activeSession.startDate ?? ""),
      ),
      onSessionEnded: () {
        controller.reload();
      },
    );
  }

  _noActiveSession(GroupDetailsUiState uiState) {
    return Column(spacing: 15, mainAxisSize: MainAxisSize.min, children: [
      AppTextWidget(
        "No Active Sessions".tr,
        style: AppTextStyle.value,
      ),
      _startSession(uiState)
    ]);
  }

  _startSession(GroupDetailsUiState uiState) => Center(
        child: StartSessionButtonWidget(
          groupId: uiState.groupId,
          studentsCount: uiState.students.length,
          onSessionStarted: () {
            controller.reload();
          },
        ),
      );

  _viewSessionsSection(GroupDetailsUiState uiState) {
    return InkWell(
      onTap: () {
        onViewAllSessionClick(uiState);
      },
      child: Container(
        width: double.infinity,
        decoration: AppBackgroundStyle.backgroundWithShadow(),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
                child: AppTextWidget("View All Sessions".tr,
                    style: AppTextStyle.value)),
            ForwardArrowWidget()
          ],
        ),
      ),
    );
  }

  void onViewAllSessionClick(GroupDetailsUiState uiState) {
    AppNavigator.navigateToSessionsList(
        SessionListArgsModel(groupId: uiState.groupId));
  }

  Widget _showAllStudents(List<GroupDetailsStudentItemUiState> students) {
    return InkWell(
      onTap: () {
        onViewAllStudentsClick(students);
      },
      child: AppTextWidget(
        "All Students".tr,
        style: AppTextStyle.teshrinArLtRegular.copyWith(
            decoration: TextDecoration.underline,
            fontSize: 15,
            color: AppColors.appMainColor),
      ),
    );
  }

  void onViewAllStudentsClick(List<GroupDetailsStudentItemUiState> students) {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        backgroundColor: AppColors.scaffoldBackgroundColor,
        context: context,
        builder: (context) => StudentsGroupListSearchWidget(
              query: "",
              students: students,
              onStudentItemClick: (uiState) {
                onStudentItemClick(uiState);
              },
            ));
  }

  @override
  void onResumedNavigatedBack() {
    controller.onResume();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_group_details_response.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/group_details/states/group_details_ui_state.dart';
import 'package:teacher_app/screens/home/states/running_session_item_ui_state.dart';
import 'package:teacher_app/screens/student_details/args/student_details_arg_model.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/day_utils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/day_with_icon_widget.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:teacher_app/widgets/edit_icon_widget.dart';
import 'package:teacher_app/widgets/forward_arrow_widget.dart';
import 'package:teacher_app/widgets/grade_with_icon_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'package:teacher_app/widgets/sessions/running_session_item_widget.dart';
import 'package:teacher_app/widgets/sessions/start_session_button_widget.dart';
import 'package:teacher_app/widgets/students/student_item_widget.dart';

import '../../domain/states/end_session_state.dart';
import '../../domain/states/start_session_state.dart';
import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/groups/group_student_item_widget.dart';
import '../../widgets/groups/states/group_student_item_ui_state.dart';
import '../group_edit/args/edit_group_args_model.dart';
import '../groups/groups_state.dart';
import '../sessions_list/args/session_list_args_model.dart';
import 'group_details_controller.dart';
import 'states/group_details_state.dart';
import 'states/group_details_student_item_ui_state.dart';

class GroupDetailsScreen extends StatefulWidget {
  const GroupDetailsScreen({super.key});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  final GroupDetailsController controller = Get.put(GroupDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppToolbarWidget.appBar("Group Details".tr,
            actions: [_deleteIcon()]),
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
      spacing: 10,
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
          _groupDay(
              "${AppDateUtils.getDayName(uiState.groupDay)} : ${uiState.timeFrom} - ${uiState.timeTo}"),
          _grade(uiState.grade),
        ],
      ),
    );

    var endIcon = EditIconWidget(onClick: onEditClick);
    return _sectionLabelValue("Group Info".tr, content, endIcon);
  }

  Widget _studentsSection(GroupDetailsUiState uiState) {
    return _sectionLabelValue("Students".tr, _studentsList(uiState.students));
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
    return DayWithIconWidget(day);
  }

  _grade(String grade) {
    return GradeWithIconWidget(grade);
  }

  Widget _label(String text) => AppTextWidget(text, style: AppTextStyle.label);

  Widget _value(String text) => AppTextWidget(text, style: AppTextStyle.value);

  Widget _sectionLabelValue(String label, Widget content, [Widget? endIcon]) {
    return Container(
      width: double.infinity,
      decoration: AppBackgroundStyle.backgroundWithShadow(),
      padding: EdgeInsets.all(10),
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

  _studentsList(List<GroupDetailsStudentItemUiState> student) {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // disables ListView scroll
        itemBuilder: (context, index) {
          var item = student[index];
          return GroupStudentItemWidget(
            uiState: GroupStudentItemUiState(
              id: item.studentId,
              name: item.studentName,
              parentPhone: item.studentParentPhone,
            ),
            onItemClick: (uiState) {
              onStudentItemClick(uiState);
            },
          );
        },
        separatorBuilder: (context, index) => Divider(
              height: 1,
            ),
        itemCount: student.length);
  }

  _editIcon() {
    return EditIconWidget(onClick: onEditClick);
  }

  _deleteIcon() {
   return Obx((){
      var state = controller.state.value;
      if(state is GroupDetailsStateSuccess){
        return DeleteIconWidget(onClick: (){
          onDeleteClick(state.uiState);
        });
      }
      return Container();
    });
  }

  onEditClick() async {
    var uiState = controller.getGroupDetailsUiState();
    var args = EditGroupArgsModel(
        groupId: uiState?.groupId ?? "",
        groupName: uiState?.groupName ?? "",
        groupDay: uiState?.groupDay ?? 0,
        timeFrom: uiState?.timeFrom ?? "",
        timeTo: uiState?.timeTo ?? "",
        gradeName: uiState?.grade ?? "",
        gradeId: uiState?.gradeId ?? "",
        students: uiState?.students ?? List.empty());

    var result = await AppNavigator.navigateToEditGroup(args);

    if (result == true) {
      controller.reload();
    }
  }

  onDeleteClick(GroupDetailsUiState uiState) {
    showConfirmationMessage("${"Are you sure to delete ?".tr} ${uiState.groupName}", (){
      showDialogLoading();
      controller.deleteGroup(uiState).listen((event) {
        hideDialogLoading();
        if(event.isSuccess){
          Get.back();
          return;
        }
        if(event.isError){
          showErrorMessage(event.error?.toString());
        }
      },);
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
          date: AppDateUtils.parseStringToDateTime(
              activeSession.startDate ?? "")),
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
      _startSession(uiState.groupId)
    ]);
  }

  _startSession(String groupId) => Center(
        child: StartSessionButtonWidget(
          name: "",
          groupId: groupId,
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
    AppNavigator.navigateToSessionsList(SessionListArgsModel(groupId: uiState.groupId));
  }
}

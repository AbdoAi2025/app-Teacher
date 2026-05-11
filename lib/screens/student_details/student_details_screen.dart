import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/group_details/args/group_details_arg_model.dart';
import 'package:teacher_app/screens/sessions_list/args/session_list_args_model.dart';
import 'package:teacher_app/screens/student_details/states/student_details_ui_state.dart';
import 'package:teacher_app/screens/student_details/student_details_controller.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/day_utils.dart';
import 'package:teacher_app/utils/extensions_utils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:teacher_app/widgets/edit_icon_widget.dart';
import 'package:teacher_app/widgets/forward_arrow_widget.dart';
import 'package:teacher_app/widgets/key_value_row_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/phone_with_icon_widget.dart';
import 'package:teacher_app/widgets/select_group_bottom_sheet.dart';
import 'package:teacher_app/widgets/time_with_icon_widget.dart';
import 'package:teacher_app/widgets/grades_selection_bottom_sheet.dart';
import 'package:teacher_app/domain/usecases/upgrade_student_use_case.dart';
import 'package:teacher_app/requests/upgrade_student_request.dart';
import '../../bottomsheets/setting_bottom_sheet.dart';
import '../../data/responses/get_student_details_response.dart';
import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../../utils/localized_name_model.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/primary_button_widget.dart';
import '../../widgets/section_widget.dart';
import '../../widgets/student_group_item_widget.dart';
import '../../widgets/student_grade_item_widget.dart';
import '../student_edit/args/edit_student_args_model.dart';
import '../sessions_list/args/session_list_args_model.dart';
import '../student_reports/args/student_reports_args_model.dart';
import 'states/student_details_state.dart';

class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  final StudentDetailsController controller =
      Get.put(StudentDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppToolbarWidget.appBar(title: "Student Details".tr,
            actions: [_settingsIcon()]),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: RefreshIndicator(
            onRefresh: () async {
              onRefresh();
            },
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: _contentState()),
          ),
        ));
  }

  Widget _contentState() {
    return Obx(() {
      var state = controller.state.value;
      switch (state) {
        case StudentDetailsStateLoading():
          return _showLoading();
        case StudentDetailsStateInvalidArgs():
          return Center(child: Text("Invalid Args"));
        case StudentDetailsStateSuccess():
          return _content(state);
        case StudentDetailsStateError():
          return Center(child: Text(state.exception.toString()));
      }
    });
  }

  _showLoading() {
    return Center(child: LoadingWidget());
  }

  _content(StudentDetailsStateSuccess state) {
    var uiState = state.uiState;
    return Column(
      spacing: 20,
      mainAxisSize: MainAxisSize.min,
      children: [
        _studentInfoSection(uiState),
        // _groupSection(uiState),
        _availableGroupsSection(uiState),
        if (uiState.grades.isNotEmpty) _availableGradesSection(uiState),
        _sessionListSection(uiState),
        _viewAllSessionSection(uiState),
      ],
    );
  }

  _settingsIcon() {
    return Obx(() {
      var state = controller.state.value;
      if (state is StudentDetailsStateSuccess) {
        return IconButton(
          icon: Icon(Icons.settings, color: AppColors.appMainColor),
          onPressed: () => _showSettingsBottomSheet(state.uiState),
        );
      }
      return Container();
    });
  }

  _studentInfoSection(StudentDetailsUiState uiState) {
    return SectionWidget(
      title: "Student Info".tr,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _studentName(uiState.studentName),
            _parentPhone(uiState.parentPhone),
            if (uiState.phone.isNotEmpty) _studentPhone(uiState.phone),
          ],
        ),
      ),
    );
  }

  Widget _sessionListSection(StudentDetailsUiState uiState) {
    return SectionWidget(
      child: InkWell(
        onTap: () => AppNavigator.navigateToSessionsList(
          SessionListArgsModel(studentId: uiState.studentId),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppTextWidget(
                "Sessions".tr,
                style: AppTextStyle.value,
              ),
            ),
            ForwardArrowWidget(),
          ],
        ),
      ),
    );
  }

  _viewAllSessionSection(StudentDetailsUiState uiState) {
    return SectionWidget(
      child: InkWell(
        onTap: () {
          onViewAllSessionsClick(uiState);
        },
        child: Row(
          children: [
            Expanded(
              child: AppTextWidget(
                "View Full Report".tr,
                style: AppTextStyle.value,
              ),
            ),
            if (uiState.groupId.isNotEmpty) ForwardArrowWidget()
          ],
        ),
      ),
    );
  }

  _studentName(String name) {
    return LabelValueRowWidget(label: "Student Name".tr, value: name);
  }

  _parentPhone(String name) {
    return LabelValueRowWidget(
      label: "Parent Phone".tr,
      valueWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhoneWithIconWidget(
            name,
            hideIcon: true,
            showCallIcon: true,
          ),
        ],
      ),
    );
  }

  _studentPhone(String name) {
    return LabelValueRowWidget(
      label: "Student Phone".tr,
      valueWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhoneWithIconWidget(
            name,
            hideIcon: true,
            showCallIcon: true,
          ),
        ],
      ),
    );
  }


  _groupName(StudentDetailsUiState uiState) {

    var groupId = uiState.groupId;
    var groupName = uiState.groupName;
     groupName = groupId.isEmpty ? "No Group".tr : groupName ;

    return LabelValueRowWidget(
        label: "Group Name".tr,
        mainAxisSize: MainAxisSize.max,
        valueWidget:  Row(
          children: [
            Expanded(child: AppTextWidget(groupName , style: AppTextStyle.value,)),
            // if(groupId.isEmpty)
            //   _addToGroup(uiState)
          ],
        ));
  }

  _groupDateTime(StudentDetailsUiState uiState) {
    var day = AppDateUtils.getDayName(uiState.groupDay).tr;
    return LabelValueRowWidget(
        label: "Day".tr,
        value: "$day , ${uiState.groupTimeFrom} - ${uiState.groupTimeTo}");
  }

  _label(String text) => AppTextWidget(text, style: AppTextStyle.label);

  _value(String text) => AppTextWidget(text, style: AppTextStyle.value);

  Widget _sectionLabelValue(String label, Widget content) {
    return Container(
      width: double.infinity,
      decoration: AppBackgroundStyle.getColoredBackgroundRounded(
          15, AppColors.color_E8E5E0),
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: SizedBox(width: double.infinity, child: content),
          ),
        ],
      ),
    );
  }

  _editIcon() {
    return EditIconWidget(onClick: onEditClick);
  }

  _deleteIcon() {
    return DeleteIconWidget(onClick: onDeleteClick);
  }

  onEditClick() async {
    var uiState = controller.getStudentDetailsUiState();
    var args = EditStudentArgsModel(
      studentId: uiState?.studentId ?? "",
      studentName: uiState?.studentName ?? "",
      gradeId: uiState?.gradeId ?? 0,
      gradeName: uiState?.gradeName ?? "",
      parentPhone: uiState?.parentPhone ?? "",
      studentPhone: uiState?.phone ?? "",
    );
    var result = await AppNavigator.navigateToEditStudent(args);
    if (result == true) {
      controller.reload();
    }
  }

  onDeleteClick() {

    showConfirmationMessage("${"Are you sure to delete ?".tr} ${controller.getStudentDetailsUiState()?.studentName ?? ""}", (){
      showDialogLoading();
      controller.deleteStudent().listen((event) {
        hideDialogLoading();
        if(event.isSuccess){
           onBack();
           return;
        }

        if(event.isError){
          showErrorMessage(event.error?.toString());
        }

      },);

    });

  }

  onRefresh() {
    controller.onRefresh();
  }

  Future<void> onGroupClick(StudentDetailsUiState uiState) async {
    if (uiState.groupId.isEmpty) {
      return;
    }

    var result = await AppNavigator.navigateToGroupDetails(
        GroupDetailsArgModel(id: uiState.groupId));
    if (result == true) {
      onRefresh();
    }
  }

  void onViewAllSessionsClick(StudentDetailsUiState uiState) {
    AppNavigator.navigateToStudentReports(StudentReportsArgsModel(studentId: uiState.studentId));
  }

  void onAddToGroupClick(StudentDetailsUiState uiState) {
    SelectGroupBottomSheet.show(
      context: context,
      onGroupSelected: (group) {
        showConfirmationMessage(
          sprintf("Are you sure to add this student to this group %s ?".tr, [group.groupName]),
          () {
            showDialogLoading();
            controller.addStudentToGroup(group.groupId).listen((event) {
              hideDialogLoading();
              if (event.isSuccess) {
                controller.reload();
                return;
              }
              if (event.isError) {
                showErrorMessage(event.error?.toString());
              }
            });
          },
        );
      },
    );
  }

  void onBack() {
    Get.back(result: true);
  }

  _showSettingsBottomSheet(StudentDetailsUiState uiState) {
    SettingBottomSheet.show(
      context: context,
        itemsModels : [
          SettingItemModel.editItem(() {
            onEditClick();
          }),
          SettingItemModel.deleteItem(() {
            onDeleteClick();
          }),
        ]
    );

  }


  Widget _availableGroupsSection(StudentDetailsUiState uiState) {
    return SizedBox(
      width: double.infinity,
      child: SectionWidget(
        title: "Groups".tr,
        isCard: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            ...uiState.groups.map((group) => StudentGroupItemWidget(
              group: group,
              uiState: uiState,
              onRemoveTap: () => _onGroupRemoveClick(group, uiState),
              onGroupTap: () => AppNavigator.navigateToGroupDetails(
                GroupDetailsArgModel(id: group.groupId ?? ''),
              ),
            )),

            if(uiState.showAddStudentToGroup) _addStudentToGroupButton(uiState)

          ],
        ),
      ),
    );
  }


  Widget _availableGradesSection(StudentDetailsUiState uiState) {
    return SectionWidget(
      title: "Grades".tr,
      isCard: false,
      child: Column(
        spacing: 10,
        children: uiState.grades.map((grade) => StudentGradeItemWidget(
          grade: grade,
          uiState: uiState,
          onUpgradeTap: () => _onGradeUpgradeClick(grade),
          onEditClick: () => _onUpdateGradeClick(grade, uiState),
        )).toList(),
      ),
    );
  }


  void _onGroupRemoveClick(StudentGroupApiModel group, StudentDetailsUiState uiState) {
    showConfirmationMessage(
      sprintf("Are you sure to remove this student from this group %s ?".tr, [group.groupName ?? ""]),
      () {
        showDialogLoading();
        controller.removeStudentFromGroup(group.groupId ?? "").listen((event) {
          hideDialogLoading();
          if (event.isSuccess) {
            controller.reload();
            return;
          }
          if (event.isError) {
            showErrorMessage(event.error?.toString());
          }
        });
      },
    );
  }

  void _onGradeUpgradeClick(StudentGradeApiModel grade) {
    final uiState = controller.getStudentDetailsUiState();
    if (uiState == null) return;

    GradesSelectionBottomSheet.show(
      context: context,
      currentGradeId: grade.gradeId.toString(),
      onGradeSelected: (selectedGrade) async {
        await _upgradeStudentGrade(uiState, selectedGrade.id ?? 0);
      },
    );
  }

  Future<void> _upgradeStudentGrade(StudentDetailsUiState uiState, int newGradeId) async {
    if (newGradeId <= 0) {
      showErrorMessage('Invalid grade selected'.tr);
      return;
    }

    final request = UpgradeStudentRequest(
      studentId: uiState.studentId,
      gradeId: newGradeId,
    );

    showDialogLoading();

    try {
      final useCase = UpgradeStudentUseCase();
      final result = await useCase.execute(request);

      hideDialogLoading();

      if (result.isSuccess) {
        showSuccessMessage('Student grade updated successfully'.tr);
        controller.reload(); // Reload to show updated grade
      } else {
        showErrorMessage(result.error?.toString() ?? 'Failed to update grade'.tr);
      }
    } catch (e) {
      hideDialogLoading();
      showErrorMessage(e.toString());
    }
  }

  void _onUpdateGradeClick(StudentGradeApiModel grade, StudentDetailsUiState uiState) {
    GradesSelectionBottomSheet.show(
      context: context,
      currentGradeId: grade.gradeId.toString(),
      onGradeSelected: (selectedGrade) {

        var message = sprintf( "Are you sure to update this grade from '%s' to '%s'".tr , [grade.localizedName?.name ?? "" , selectedGrade.localizedName?.name ?? ""]);

        showConfirmationMessage(
          message,
          () {
            showDialogLoading();
            controller.updateStudentGrade(grade.id.toString(), selectedGrade.id.toString()).listen((event) {
              hideDialogLoading();
              if (event.isSuccess) {
                controller.reload();
                return;
              }
              if (event.isError) {
                showErrorMessage(event.error?.toString());
              }
            });
          },
        );
      },
    );
  }

  _addStudentToGroupButton(StudentDetailsUiState uiState) {
    return Center(
      child: PrimaryButtonWidget(
        text: "Add to Group".tr,
        onClick: () {
          onAddToGroupClick(uiState);
        },
      ),
    );
  }
}

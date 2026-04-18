import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/group_details/args/group_details_arg_model.dart';
import 'package:teacher_app/screens/sessions_list/args/session_list_args_model.dart';
import 'package:teacher_app/screens/student_details/states/student_details_ui_state.dart';
import 'package:teacher_app/screens/student_details/student_details_controller.dart';
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
import '../../widgets/section_widget.dart';
import '../student_edit/args/edit_student_args_model.dart';
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
        if (uiState.groups.isNotEmpty) _availableGroupsSection(uiState),
        if (uiState.grades.isNotEmpty) _availableGradesSection(uiState),
        if (uiState.groupId.isNotEmpty) _viewAllSessionSection(uiState),
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
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _studentName(uiState.studentName),
          _parentPhone(uiState.parentPhone),
          if (uiState.phone.isNotEmpty) _studentPhone(uiState.phone),
          _grade(uiState.gradeName),
        ],
      ),
    );
  }

  _groupSection(StudentDetailsUiState uiState) {
    return SectionWidget(
      title: "Group Info".tr,
      child: InkWell(
        onTap: () {
          onGroupClick(uiState);
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _groupName(uiState),
                  if (uiState.groupId.isNotEmpty) ...{
                    _groupDateTime(uiState),
                  }
                  // _groupDay(""),
                ],
              ),
            ),
            if (uiState.groupId.isNotEmpty) ForwardArrowWidget()
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
      valueWidget: PhoneWithIconWidget(
        name,
        hideIcon: true,
        showCallIcon: true,
      ),
    );
  }

  _studentPhone(String name) {
    return LabelValueRowWidget(
      label: "Student Phone".tr,
      valueWidget: PhoneWithIconWidget(
        name,
        hideIcon: true,
        showCallIcon: true,
      ),
    );
  }

  _grade(String value) {
    return LabelValueRowWidget(label: "Grade Name".tr, value: value);
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
          SettingItemModel.upgradeItem(() {
            onUpgradeClick();
          }),
          SettingItemModel.deleteItem(() {
            onDeleteClick();
          }),
          if(uiState.groupId.isNotEmpty)
          SettingItemModel.addStudentToGroup(() {
            onAddToGroupClick(uiState);
          }),
        ]
    );

  }

  void onUpgradeClick() {
    final uiState = controller.getStudentDetailsUiState();
    if (uiState == null) return;

    GradesSelectionBottomSheet.show(
      context: context,
      currentGradeId: uiState.gradeId.toString(),
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

  Widget _availableGroupsSection(StudentDetailsUiState uiState) {
    return SectionWidget(
      title: "Available Groups".tr,
      child: Column(
        spacing: 10,
        children: uiState.groups.map((group) => _groupItem(group, uiState)).toList(),
      ),
    );
  }

  Widget _groupItem(StudentGroupApiModel group, StudentDetailsUiState uiState) {
    final isCurrentGroup = group.groupId == uiState.groupId;
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentGroup ? AppColors.appMainColor.withOpacity(0.1) : AppColors.white,
        border: Border.all(
          color: isCurrentGroup ? AppColors.appMainColor : AppColors.color_DBD5CC,
          width: isCurrentGroup ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppTextWidget(
                        group.groupName ?? "Unknown Group".tr,
                        style: AppTextStyle.label.copyWith(
                          fontWeight: isCurrentGroup ? FontWeight.bold : FontWeight.normal,
                          color: isCurrentGroup ? AppColors.appMainColor : AppColors.colorBlack,
                        ),
                      ),
                    ),
                    if (isCurrentGroup)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.appMainColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AppTextWidget(
                          "Current".tr,
                          style: AppTextStyle.small.copyWith(color: AppColors.white),
                        ),
                      ),
                  ],
                ),
                if (group.groupDay != null && group.groupTimeFrom != null && group.groupTimeTo != null)
                  AppTextWidget(
                    "${AppDateUtils.getDayName(group.groupDay!).tr}, ${group.groupTimeFrom} - ${group.groupTimeTo}",
                    style: AppTextStyle.small.copyWith(color: AppColors.textSecondaryColor),
                  ),
              ],
            ),
          ),
          if (!isCurrentGroup) ...[
            SizedBox(width: 8),
            InkWell(
              onTap: () => _onGroupSwitchClick(group, uiState),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.appMainColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AppTextWidget(
                  "Switch".tr,
                  style: AppTextStyle.small.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _availableGradesSection(StudentDetailsUiState uiState) {
    return SectionWidget(
      title: "Available Grades".tr,
      child: Column(
        spacing: 10,
        children: uiState.grades.map((grade) => _gradeItem(grade, uiState)).toList(),
      ),
    );
  }

  Widget _gradeItem(StudentGradeApiModel grade, StudentDetailsUiState uiState) {
    final isCurrentGrade = grade.id == uiState.gradeId.toString();
    final gradeName = LocalizedNameModel(
      nameEn: grade.nameEn ?? "",
      nameAr: grade.nameAr ?? "",
    ).toLocalizedName();

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentGrade ? AppColors.appMainColor.withOpacity(0.1) : AppColors.white,
        border: Border.all(
          color: isCurrentGrade ? AppColors.appMainColor : AppColors.color_DBD5CC,
          width: isCurrentGrade ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AppTextWidget(
                    gradeName,
                    style: AppTextStyle.label.copyWith(
                      fontWeight: isCurrentGrade ? FontWeight.bold : FontWeight.normal,
                      color: isCurrentGrade ? AppColors.appMainColor : AppColors.colorBlack,
                    ),
                  ),
                ),
                if (isCurrentGrade)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.appMainColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppTextWidget(
                      "Current".tr,
                      style: AppTextStyle.small.copyWith(color: AppColors.white),
                    ),
                  ),
              ],
            ),
          ),
          if (!isCurrentGrade) ...[
            SizedBox(width: 8),
            InkWell(
              onTap: () => _onGradeUpgradeClick(grade),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.appMainColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AppTextWidget(
                  "Upgrade".tr,
                  style: AppTextStyle.small.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onGroupSwitchClick(StudentGroupApiModel group, StudentDetailsUiState uiState) {
    // TODO: Implement group switch functionality
    // This would typically involve calling an API to move the student to a different group
    showSuccessMessage("Group switch functionality not implemented yet".tr);
  }

  void _onGradeUpgradeClick(StudentGradeApiModel grade) {
    final gradeId = int.tryParse(grade.id ?? "");
    if (gradeId != null) {
      final uiState = controller.getStudentDetailsUiState();
      if (uiState != null) {
        _upgradeStudentGrade(uiState, gradeId);
      }
    }
  }
}

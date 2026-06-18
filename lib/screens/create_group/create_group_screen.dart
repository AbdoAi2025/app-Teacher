import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/screens/create_group/states/create_group_state.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'create_group_controller.dart';
import 'steps/add_students_step.dart';
import 'steps/add_timings_step.dart';
import 'steps/group_info_step.dart';
import 'steps/group_step_indicator.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => CreateGroupScreenState();
}

class CreateGroupScreenState extends State<CreateGroupScreen> {
  final CreateGroupController _controller = Get.put(CreateGroupController());
  final PageController _pageController = PageController();

  CreateGroupController getController() => _controller;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolbarWidget.appBar(title: getScreenTitle()),
      body: Column(
        children: [
          GroupStepIndicator(controller: getController()),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GroupInfoStep(
                  controller: getController(),
                  onNext: _onStep1Next,
                ),
                AddStudentsStep(
                  controller: getController(),
                  studentsController:
                      getController().studentsSelectionController,
                  onPrevious: _onPreviousToStep1,
                  onNext: _onStep2Next,
                  onAddStudent: _onAddStudent,
                ),
                AddTimingsStep(
                  controller: getController(),
                  onPrevious: _onPreviousToStep2,
                  onDone: _onStep3Done,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onStep1Next() {
    final ok = getController().validateGroupInfo();
    if (ok) {
      getController().currentStep.value = 1;
      _animateToPage(1);
    }
  }

  void _onStep2Next() {
    getController().currentStep.value = 2;
    _animateToPage(2);
  }

  void _onPreviousToStep1() {
    getController().stepError.value = '';
    getController().currentStep.value = 0;
    _animateToPage(0);
  }

  void _onPreviousToStep2() {
    getController().stepError.value = '';
    getController().currentStep.value = 1;
    _animateToPage(1);
  }

  Future<void> _onStep3Done() async {
    showConfirmationMessage(
      AppStringsKeys.areYouSureYouWantToSave.tr,
      () async {
        final ok = await getController().submitAll();
        if (!mounted) return;
        if (ok) Get.back(result: true);
      },
    );
  }

  Future<void> _onAddStudent() async {
    await AppNavigator.navigateToAddStudent();
    getController().studentsSelectionController.loadStudents();
  }

  // ----------------------------------------------------------------
  // Hooks for subclasses (EditGroupScreen legacy compatibility)
  // ----------------------------------------------------------------
  String getScreenTitle() => AppStringsKeys.createGroup.tr;
  String getSubmitButtonText() => AppStringsKeys.createGroup.tr;

  void showError(CreateGroupStateError result) {
    Get.snackbar('Error', result.exception.toString());
  }

  void onCreateGroupSuccess(SaveGroupStateSuccess result) {
    Get.back(result: true);
  }

  void onSaveGroupResult(CreateGroupState event) {
    hideDialogLoading();
    switch (event) {
      case CreateGroupStateLoading():
        showDialogLoading();
      case SaveGroupStateSuccess():
        onCreateGroupSuccess(event);
      case CreateGroupStateFormValidation():
        break;
      case CreateGroupStateError():
        showError(event);
    }
  }
}
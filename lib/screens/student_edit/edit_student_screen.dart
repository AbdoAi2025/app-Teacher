import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/student_add/add_student_controller.dart';
import 'package:teacher_app/screens/student_add/add_student_screen.dart';
import 'package:teacher_app/screens/student_edit/edit_student_controller.dart';
import 'package:teacher_app/utils/message_utils.dart';
import '../../widgets/dialog_loading_widget.dart';
import '../student_add/states/add_student_state.dart';
import 'states/update_student_state.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class EditStudentScreen extends AddStudentScreen {

  const EditStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends AddStudentScreenState {

  final EditStudentController _controller = Get.put(EditStudentController());

  @override
  AddStudentController getController() {
    return _controller;
  }

  @override
  String getScreenTitle() {
    return AppStringsKeys.editStudent.tr;
  }

  @override
  String getSubmitButtonText() {
    return AppStringsKeys.update.tr;
  }

  @override
  void onSaveStudentResult(AddStudentState event) {
    var result = event;
    hideDialogLoading();
    switch (result) {
      case AddStudentStateLoading():
        showDialogLoading();
        break;
      case UpdateStudentStateStudentNotFound():
        showErrorMessagePopup(AppStringsKeys.studentNotFound.tr);
        break;
      case SaveStateSuccess():
        onSaveSuccess(result);
        break;
      case AddStudentStateFormValidation():
        break;
      case AddStudentStateError():
        showErrorMessagePopup(result.exception?.toString() ?? "");
    }
  }

  @override
  Widget gradeField() => const SizedBox.shrink();

  @override
  void onSaveSuccess(SaveStateSuccess result) {
    showSuccessMessage(AppStringsKeys.studentEditedSuccessfully.tr);
    super.onSaveSuccess(result);
  }
}

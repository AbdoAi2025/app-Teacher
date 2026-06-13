import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/create_group/create_group_controller.dart';
import 'package:teacher_app/screens/create_group/states/create_group_state.dart';
import 'package:teacher_app/utils/message_utils.dart';
import '../../widgets/dialog_loading_widget.dart';
import '../create_group/create_group_screen.dart';
import 'edit_group_controller.dart';
import 'states/update_group_state.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class EditGroupScreen extends CreateGroupScreen {

  const EditGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => EditGroupScreenState();
}

class EditGroupScreenState extends CreateGroupScreenState {

  final EditGroupController _controller = Get.put(EditGroupController());

  @override
  CreateGroupController getController() {
    return _controller;
  }

  @override
  String getScreenTitle() {
    return AppStringsKeys.editGroup.tr;
  }

  @override
  String getSubmitButtonText() {
    return AppStringsKeys.update.tr;
  }

  @override
  void onSaveGroupResult(CreateGroupState event) {
    var result = event;
    hideDialogLoading();
    switch (result) {
      case CreateGroupStateLoading():
        showDialogLoading();
        break;
      case UpdateGroupStateGroupNotFound():
        showErrorMessagePopup(AppStringsKeys.groupNotFound.tr);
        break;
      case SaveGroupStateSuccess():
        onCreateGroupSuccess(result);
        break;
      case CreateGroupStateFormValidation():
        break;
      case CreateGroupStateError():
        showError(result);
    }
  }

  @override
  void onCreateGroupSuccess(SaveGroupStateSuccess result) {
    showSuccessMessage(AppStringsKeys.groupEditedSuccessfully.tr);
    super.onCreateGroupSuccess(result);
  }
}
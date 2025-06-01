import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/create_group/create_group_screen.dart';
import 'package:teacher_app/utils/message_utils.dart';
import '../../widgets/dialog_loading_widget.dart';
import '../create_group/create_group_controller.dart';
import '../create_group/states/create_group_state.dart';
import 'edit_group_controller.dart';
import 'states/update_group_state.dart';

class EditGroupScreen extends CreateGroupScreen {

  const EditGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends CreateGroupScreenState {
  final EditGroupController _controller = Get.put(EditGroupController());

  @override
  CreateGroupController getController() {
    return _controller;
  }

  @override
  String getScreenTitle() {
    return "Edit Group".tr;
  }

  @override
  String getSubmitButtonText() {
    return "Update";
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
        showErrorMessagePopup("Group not found".tr);
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
    showSuccessMessage("Group edited successfully".tr);
    super.onCreateGroupSuccess(result);
  }
}

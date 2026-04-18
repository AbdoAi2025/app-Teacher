import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/group_edit/edit_group_screen.dart';
import 'package:teacher_app/utils/message_utils.dart';
import '../../widgets/dialog_loading_widget.dart';
import '../create_group/create_group_controller.dart';
import '../create_group/create_group_screen.dart';
import '../create_group/states/create_group_state.dart';
import '../group_edit/edit_group_controller.dart';
import '../group_edit/states/update_group_state.dart';
import 'upgrade_group_controller.dart';

class UpgradeGroupScreen extends EditGroupScreen {

  const UpgradeGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _UpgradeGroupScreenState();
}

class _UpgradeGroupScreenState extends EditGroupScreenState {

  final UpgradeGroupController _upgradeController = Get.put(UpgradeGroupController());

  @override
  CreateGroupController getController() {
    return _upgradeController;
  }

  @override
  String getScreenTitle() {
    return "Upgrade Group".tr;
  }

  @override
  String getSubmitButtonText() {
    return "Upgrade".tr;
  }

  @override
  void onCreateGroupSuccess(SaveGroupStateSuccess result) {
    showSuccessMessage("Group upgraded successfully".tr);
    super.onCreateGroupSuccess(result);
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/create_group/create_group_controller.dart';
import 'package:teacher_app/screens/group_details/args/group_details_arg_model.dart';
import 'package:teacher_app/screens/group_edit/edit_group_screen.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import '../create_group/create_group_screen.dart';
import '../create_group/states/create_group_state.dart';
import 'upgrade_group_controller.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

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
    return AppStringsKeys.upgradeGroup.tr;
  }

  @override
  String getSubmitButtonText() {
    return AppStringsKeys.upgrade.tr;
  }

  @override
  Future<void> onCreateGroupSuccess(SaveGroupStateSuccess result) async {
    await showSuccessMessage(AppStringsKeys.groupUpgradedSuccessfully.tr);
    final groupId = _upgradeController.createdGroupId;
    appLog("onCreateGroupSuccess groupId:$groupId");
    if (groupId != null) {
      AppNavigator.replaceWithGroupDetails(GroupDetailsArgModel(id: groupId));
    } else {
      Get.back(result: true);
    }
  }
}
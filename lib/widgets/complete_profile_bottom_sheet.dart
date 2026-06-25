import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/edit_profile/edit_profile_screen.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class CompleteProfileBottomSheet {
  CompleteProfileBottomSheet._();

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onSuccess,
  }) async {
    showConfirmationMessage(
      AppStringsKeys.completeProfileMessage.tr,
      () => _openSheet(context, onSuccess: onSuccess),
      barrierDismissible: false,
      negativeButtonText: '',
      showCancelBtn: false,
      positiveButtonText: AppStringsKeys.completeNow.tr,
    );
  }

  static Future<void> _openSheet(
    BuildContext context, {
    required VoidCallback onSuccess,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      builder: (_) => EditProfileScreen(onSaved: onSuccess),
    );
  }
}
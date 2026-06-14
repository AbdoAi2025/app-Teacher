import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/info_chip_widget.dart';
import 'package:teacher_app/widgets/sessions/start_session/start_session_form_model.dart';

import '../../data/requests/start_session_request.dart';
import '../../dialogs/user_not_subscribed_dialog.dart';
import '../../domain/states/start_session_state.dart';
import '../../domain/usecases/start_session_use_case.dart';
import '../../utils/message_utils.dart';
import '../dialog_loading_widget.dart';
import '../primary_button_widget.dart';
import 'start_session_form_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class StartSessionButtonWidget extends StatelessWidget {
  final String timingId;
  final int studentsCount;
  final Function() onSessionStarted;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const StartSessionButtonWidget(
      {super.key,
      required this.timingId,
      required this.studentsCount,
      required this.onSessionStarted,
      this.padding,
      this.textStyle,
      });

  @override
  Widget build(BuildContext context) {


    return InkWell(
      onTap: () {
        onStartSessionClick();
      },
      child: InfoChipWidget(
        text: AppStringsKeys.startSession.tr,
        icon: Icons.play_circle_outline,
        color: AppColors.green,
      ),
    );

   return AppTextWidget(
      AppStringsKeys.startSession.tr,
      style: AppTextStyle.value.copyWith(color: AppColors.primaryButtonColor, fontSize: 12 ,),
    );

    return PrimaryButtonWidget(
      text: AppStringsKeys.startSession.tr,
      padding: padding,
      textStyle: textStyle,
      onClick: () {
        onStartSessionClick();
      },
    );
  }

  void onStartSessionClick() {
    /*check if group has students*/
    if (studentsCount == 0) {
      showErrorMessage(AppStringsKeys.groupHasNoStudents.tr);
      return;
    }

    _showDialogToEnterData();
  }

  void onStartSession(StartSessionFormModel formModel) {
    startSession(formModel).listen((event) {
      hideDialogLoading();
      switch (event) {
        case StartSessionStateLoading():
          showDialogLoading();
          break;
        case StartSessionStateSuccess():
          onSessionStarted();
          break;
        case StartSessionStateNotSubscribed():
          UserNotSubscribedDialog.showUserNotSubscribedDialog(message: event.message ?? "", barrierDismissible: true);
          break;
        case StartSessionStateError():
          showErrorMessage(event.exception.toString());
          break;
      }
    });
  }

  Stream<StartSessionState> startSession(
      StartSessionFormModel formModel) async* {
    yield StartSessionStateLoading();
    StartSessionRequest request = StartSessionRequest(
        name: formModel.name,
        timingId: timingId,
        quizGrade: formModel.quizGrade);
    var result = await StartSessionUseCase().execute(request);
    if (result.isSuccess) {
      yield result.data!;
    } else {
      yield StartSessionStateError(result.error);
    }
  }

  void _showDialogToEnterData() {
    Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StartSessionFormWidget(
              onStartClick: (formModel) {
                Get.back();
                //start session api
                onStartSession(formModel);
              },
              onCancelClick: () {
                Get.back();
              },
            ),
          ),
        ),
        barrierDismissible: false);
  }
}

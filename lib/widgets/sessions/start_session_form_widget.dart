import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/utils/message_utils.dart';

import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../../utils/app_background_styles.dart';
import '../app_text_field_widget.dart';
import '../app_txt_widget.dart';
import 'start_session/start_session_form_model.dart';

class StartSessionFormWidget extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final Function(StartSessionFormModel) onStartClick;
  final Function() onCancelClick;

  StartSessionFormWidget(
      {super.key, required this.onStartClick, required this.onCancelClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      mainAxisSize: MainAxisSize.min,
      children: [_header(), _quizGradeField(),_nameField(),  _startButton()],
    );
  }

  _quizGradeField() {
    return AppTextFieldWidget(
      controller: controller,
      hint: "Quiz Grade if found".tr,
      keyboardType: TextInputType.number,
    );
  }

  _nameField() {
    return AppTextFieldWidget(
      controller: nameController,
      hint: "Session Name (Optional)".tr,
    );
  }

  _startButton() {
    return InkWell(
      onTap: () {
        _onStartSessionClick();
      },
      child: Container(
        constraints: BoxConstraints(minWidth: 200),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: AppBackgroundStyle.getColoredBackgroundRounded(
            20, AppColors.appMainColor),
        child: AppTextWidget(
          "Start".tr,
          textAlign: TextAlign.center,
          color: AppColors.white,
        ),
      ),
    );
  }

  _header() {
    return Row(
      children: [
        Expanded(
            child: Center(
                child: AppTextWidget(
          "Start session".tr,
          style: AppTextStyle.title,
        ))),
        _closeIcon()
      ],
    );
  }

  _closeIcon() {
    return InkWell(onTap: onCancelClick, child: Icon(Icons.close));
  }

  void _onStartSessionClick() {
    var inputQuizGrade = controller.text;
    var quizGradeValue = 0;
    if(inputQuizGrade.isNotEmpty){
      quizGradeValue = int.tryParse(inputQuizGrade) ?? 0;
      if (quizGradeValue <= 0) {
        showErrorMessage("please enter valid quiz grade".tr);
        return;
      }
    }

    var sessionName = nameController.text;
    onStartClick(
        StartSessionFormModel(quizGrade: quizGradeValue, name: sessionName));
  }
}

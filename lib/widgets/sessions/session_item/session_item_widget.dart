import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import '../../../screens/sessions_list/states/session_item_ui_state.dart';
import '../../../themes/txt_styles.dart';
import '../../key_value_row_widget.dart';
import '../../session_status_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class SessionItemWidget extends StatelessWidget {
  final SessionItemUiState uiState;
  final Function(SessionItemUiState) onClick;

  const SessionItemWidget(
      {super.key, required this.uiState, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onClick(uiState);
      },
      child: Container(
        decoration: AppBackgroundStyle.backgroundWithShadow(),
        padding: EdgeInsets.all(15),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(uiState.sessionName.isNotEmpty)
              _name(),
            _groupName(),
            _groupTime(),
            _date(),
            _status(),
          ],
        ),
      ),
    );
  }

  _name() {
    return AppTextWidget(uiState.sessionName , style: AppTextStyle.title);
  }

  _groupName() {
    return LabelValueRowWidget(label: AppStringsKeys.group.tr, value: uiState.groupName);
  }

  _groupTime() {
    return LabelValueRowWidget(label: AppStringsKeys.groupTime.tr, value: "${uiState.timeFrom } - ${uiState.timeTo}");
  }

  _date() {
    return LabelValueRowWidget(label: AppStringsKeys.date2.tr, value: "${uiState.date}");
  }

  _status() {
    return  SessionStatusWidget(uiState.sessionStatus);

  }
}
